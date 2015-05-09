class Asset < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  has_many :revenues, as: :item
	# validates_associated :spending, on: :create
  validates :item_type, presence: true
  validates :quantity, presence: true, numericality: true
  validates :measurement, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }

  # validates :firm_id, presence: true, numericality: { only_integer: true }	

  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
  scope :by_name, ->(name) { where(item_name: name) }
  scope :non_current, -> { where(item_type: ['Equipment', 'Plant', 'Property']) }
	scope :equipments, -> { where(item_type: 'Equipment') }
	scope :plants, -> { where(item_type: 'Plant') }
	scope :buildings, -> { where(item_type: 'Property') }
  scope :available, -> { where(status: ['Belum Habis', 'Aktif']) }

  after_touch :update_asset, :if => :available
  before_create :default_on_create
  before_save :set_attributes
  # after_update :check_status
  after_save :touch_reports

  def cost_per_unit
    (self.cost / self.quantity).round
  end

  def quantity_remaining
    self.quantity - self.quantity_used
  end

  def cost_now
    value_after_depreciation * quantity_remaining
  end

  def value_after_depreciation
    (cost_per_unit - self.accumulated_depreciation)#.round(0)
  end

  def available
    if self.status == 'Habis'
      return false
    else 
      return true
    end
  end

  def asset_code
    name = self.item_name
    type = self.item_type
    number = self.id

    return "#{name}-#{type}-#{number}"    
  end


	def date_purchased
		Spending.find_by(firm_id: firm_id, item_name: item_name).date_of_spending
	end

	def year_purchased
		date_purchased.strftime("%Y")
	end

  def related_spendings
    Spending.by_firm(firm_id).assets.by_name(item_name)
  end

  def related_earnings
    Revenue.by_firm(firm_id).assets.by_item(id)
  end  


  def find_income_statement
    IncomeStatement.find_by_firm_id_and_year(firm_id, year_purchased)
  end

  def year_remaining
    self.useful_life - (Date.today.year.to_i - year_purchased.to_i)
  end


  private

  def default_on_create
    self.status  = 'Aktif'    
  end

  def set_attributes
    set_useful_life
    set_depreciation_expense
    self.value_per_unit = self.cost_per_unit
  end

  def set_useful_life
    if self.item_type == 'Equipment'
      self.useful_life = 4
    elsif self.item_type == 'Machine'
      self.useful_life = 8
    elsif self.item_type == 'Plant'
      self.useful_life = 12
    elsif self.item_type == 'Property'
      self.useful_life = 0
    else
      self.useful_life = 1
    end
  end

  def set_depreciation_expense
    annual_depreciation = self.cost_per_unit / self.useful_life
    daily_cost = (annual_depreciation / 360).round(3)
    self.depreciation_cost = daily_cost
  end

  def calculate_accumulated_depr
    start_date = self.date_recorded
    now_date = DateTime.now.to_date
    difference = (now_date - start_date).to_i
    per_unit = (self.depreciation_cost * difference).round(3)
    return per_unit
  end

  def calculate_total_depr
    quantity_now = self.quantity - check_quantity_used
    total = calculate_accumulated_depr * quantity_now
    return total
  end  

  def touch_reports
    find_income_statement.touch
  end

  def update_asset
    update(cost: check_cost, quantity: check_quantity,
           quantity_used: check_quantity_used, 
           accumulated_depreciation: calculate_accumulated_depr,
           total_depreciation: calculate_total_depr,
           status: check_status)
  end

  def check_cost
    self.related_spendings.first.total_spent
  end

  def check_quantity
    self.related_spendings.first.quantity
  end

  def check_quantity_used
    arr = Revenue.by_firm(self.firm_id).others.by_item(self.id)
    quantity_used = arr.map{ |rev| rev.quantity }.compact.sum
    return quantity_used    
  end

  def check_status
    check_quantity_used
    if quantity_used == self.quantity
      return 'Terjual Habis'
    else
      return 'Aktif'
    end
  end

  # def reload_depreciation
  #   update(accumulated_depreciation: calculate_accumulated_depr)
  # end

end
