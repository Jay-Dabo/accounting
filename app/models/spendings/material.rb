class Material < ActiveRecord::Base
  belongs_to :spending, foreign_key: 'spending_id'
  belongs_to :firm, foreign_key: 'firm_id'
  validates_associated :spending

  validates :material_name, presence: true
  # validates :cost, presence: true
  # validates :firm_id, presence: true, numericality: { only_integer: true }

  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id) }
  scope :available, -> { where(status: ['Utuh', 'Belum Habis']) }

  before_create :default_on_create
  before_save :set_cost_attributes!
  after_touch :update_material
  after_save :touch_report

  def cost_per_unit
    (self.cost / self.quantity).round
  end

  def quantity_remaining
  	self.quantity - self.quantity_used 
  end

  def date_purchased
    Spending.find_by_firm_id_and_id(self.firm_id, self.spending_id).date_of_spending
  end

  def year_purchased
    date_purchased.strftime("%Y")
  end

  def find_report(report)
    report.find_by_firm_id_and_year(firm_id, year_purchased)
  end 


  private

  def check_used
    arr = Processing.by_material(id)
    quantity_used = arr.map(&:quantity_used).compact.sum
    return quantity_used
  end

  def check_cost_remaining
    arr = Processing.by_material(id)
    cost_used = arr.map{ |process| process['cost_used']}.compact.sum
    cost_remaining = self.cost - cost_used
    return cost_remaining
  end

  def check_cost_used
    arr = Processing.by_material(id)
    cost_used = arr.map{ |process| process['cost_used']}.compact.sum
    return cost_used
  end

  def check_status
    check_used
    if quantity_used == self.quantity
      return 'Terjual Habis'
    elsif self.quantity_remaining > 0
      return 'Belum Habis'
    else
      return 'Utuh'
    end
  end

  def default_on_create
    self.cost_used = 0
    self.quantity_used = 0
    self.status  = 'Utuh' 
    self.cost_remaining = self.cost   
  end

  def set_cost_attributes!
    self.cost_per_unit = cost_per_unit
  end

  def touch_report
    find_report(BalanceSheet).touch
  end

  def update_material
    update(quantity_used: check_used, cost_remaining: check_cost_remaining,
           cost_used: check_cost_used, status: check_status)
  end

end