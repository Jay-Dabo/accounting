class Asset < ActiveRecord::Base
  monetize :value
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

	# after_save :into_balance_sheet
  after_touch :update_asset
  after_save :touch_balance_sheet

  def asset_code
    name = self.asset_name
    type = self.asset_type
    number = self.id

    return "#{name}-#{type}-#{number}"    
  end

  def value_after_depreciation
    self.value - self.depreciation
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

  def check_unit
   arr = Revenue.by_firm(self.firm_id).others.by_item(self.id)
    unit_sold = arr.map(&:quantity).compact.sum
    unit_now = self.unit - unit_sold
    return unit_now    
  end

  private

  def touch_balance_sheet
    find_balance_sheet.touch
  end

  def update_asset
    update(unit: check_unit)
  end

# Lease goes into fixed asset
# Prepaid asset is for asset that has life below 1 year and has to be expense every month
end
