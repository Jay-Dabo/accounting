class Asset < ActiveRecord::Base
  include ActiveModel::Dirty
  
	belongs_to :spending, inverse_of: :asset, foreign_key: 'spending_id'
  belongs_to :firm, foreign_key: 'firm_id'
  has_many :revenues, as: :item
	validates_associated :spending
  validates :asset_type, presence: true
  validates :unit, presence: true, numericality: true
  validates :measurement, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :value, presence: true, numericality: true
  validates :useful_life, numericality: true
  validates :firm_id, presence: true, numericality: { only_integer: true }	

  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
  scope :current, -> { where(asset_type: ['Prepaid', 'Supply', 'OtherCurrentAsset']) }
	scope :prepaids, -> { where(asset_type: 'Prepaid') }
	scope :supplies, -> { where(asset_type: 'Supply') }
  scope :other_current, -> { where(asset_type: 'OtherCurrentAsset') }
  scope :non_current, -> { where(asset_type: ['Equipment', 'Plant', 'Property']) }
	scope :equipments, -> { where(asset_type: 'Equipment') }
	scope :plants, -> { where(asset_type: 'Plant') }
	scope :buildings, -> { where(asset_type: 'Property') }
  scope :available, -> { where(status: ['Belum Habis', 'Aktif']) }

  after_touch :update_asset
  before_create :set_value_per_unit
  before_update :check_status
  after_save :touch_reports

  def asset_code
    name = self.asset_name
    type = self.asset_type
    number = self.id

    return "#{name}-#{type}-#{number}"    
  end

  def value_after_depreciation
    self.value_per_unit - self.depreciation
  end

	def date_purchased
		Spending.find_by_firm_id_and_id(self.firm_id, self.spending_id).date_of_spending
	end

	def year_purchased
		date_purchased.strftime("%Y")
	end

  def find_balance_sheet
    BalanceSheet.find_by_firm_id_and_year(firm_id, year_purchased)
  end

  def find_income_statement
    IncomeStatement.find_by_firm_id_and_year(firm_id, year_purchased)
  end

  # def apply_depreciation
  #   if self.asset_type == 'Equipment' || self.asset_type == 'Plant'
  #     depr = self.value / self.useful_life

  #     self.increment!(:depreciation, depr)
  #     self.decrement!(:value, self.depr)
  #     find_income_statement.increment!(:operating_expense, self.depr)
  #     find_balance_sheet.decrement!(:fixed_assets, self.depr)
  #   end    
  # end

  def unit_remaining
    self.unit - self.unit_sold
  end


  private

  def set_value_per_unit
    self.value_per_unit = (self.value / self.unit).round
    self.unit_sold = 0
    self.status  = 'Aktif'
  end

  def set_useful_life
    if self.asset_type == 'Equipment'
      self.useful_life = 4
    elsif self.asset_type == 'Machine'
      self.useful_life = 8
    elsif self.asset_type == 'Plant'
      self.useful_life = 12
    elsif self.asset_type == 'Property'
      self.useful_life = 0
    else
      self.useful_life = 1
    end
  end

  def touch_reports
    find_income_statement.touch
    # find_balance_sheet.touch
  end

  def update_asset
    update(unit_sold: check_unit_sold, value: check_value)
  end

  def check_value
    arr = Revenue.by_firm(self.firm_id).others.by_item(self.id)
    unit_sold = arr.map{ |rev| rev.quantity }.compact.sum
    value_sold = unit_sold * self.value_per_unit
    value_now = self.value - value_sold
    return value_now    
  end

  def check_unit_sold
    arr = Revenue.by_firm(self.firm_id).others.by_item(self.id)
    unit_sold = arr.map{ |rev| rev.quantity }.compact.sum
    return unit_sold    
  end

  def check_status
    if self.unit_sold == self.unit
      self.status = 'Terjual Habis'
    else
      self.status = 'Aktif'
    end
  end

# Lease goes into fixed asset
# Prepaid asset is for asset that has life below 1 year and has to be expense every month
end
