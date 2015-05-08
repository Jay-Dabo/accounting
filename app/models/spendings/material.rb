class Material < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  validates_associated :firm

  validates :item_name, presence: true
  validates :cost, presence: true

  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id) }
  scope :available, -> { where(status: ['Utuh', 'Belum Habis']) }

  after_touch :update_material
  before_create :default_on_create
  after_save :touch_report

  def cost_per_unit
    (self.cost / self.quantity).round
  end

  def cost_remaining
    (self.cost - self.cost_used).round
  end

  def quantity_remaining
    (self.quantity - self.quantity_used).round
  end

  def date_purchased
    Spending.find_by(firm_id: firm_id, item_name: item_name).date_of_spending
  end

  def year_purchased
    date_purchased.strftime("%Y")
  end

  def related_spendings
    Spending.by_firm(firm_id).materials.by_name(item_name)
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

  def check_cost_used
    arr = Processing.by_material(id)
    cost_used = arr.map{ |process| process['cost_used']}.compact.sum
    return cost_used
  end

  def check_quantity_bought
    arr = Spending.by_firm(self.firm_id).materials.by_name(item_name)
    quantity_bought = arr.map{ |spe| spe.quantity }.compact.sum
    return quantity_bought
  end

  def check_cost_bought
    arr = Spending.by_firm(self.firm_id).materials.by_name(item_name)
    cost_bought = arr.map{ |spe| spe.total_spent }.compact.sum
    return cost_bought
  end

  def check_status
    if self.quantity_used == self.quantity
      return 'Terjual Habis'
    elsif self.quantity_remaining > 0
      return 'Belum Habis'
    else
      return 'Utuh'
    end
  end

  def default_on_create
    self.status  = 'Utuh'
  end

  def touch_report
    find_report(BalanceSheet).touch
  end

  def update_material
    update(quantity_used: check_used, cost_used: check_cost_used,
      cost: check_cost_bought, quantity: check_quantity_bought,
      status: check_status)
  end

end