class Product < ActiveRecord::Base
  include GeneralScoping
  belongs_to :firm, foreign_key: 'firm_id'
  has_many :revenues, as: :item

  validates_associated :firm
  validates :item_name, presence: true
  # validates :cost, presence: true, numericality: true
  # validates :firm_id, presence: true, numericality: { only_integer: true }

  scope :by_name, ->(name) { where(item_name: name) }
  scope :in_stock, -> { where('quantity > quantity_used') }
  

  after_touch :update_product
  # before_save :update_cost_remaining
  after_save :touch_report

  def current_year
    Date.today.year
  end

  def find_report(report)
    report.find_by_firm_id_and_year(firm_id, current_year)
  end 

  def cost_per_unit
    (self.cost / self.quantity).round(0)
  end
  
  def cost_remaining
    value = self.cost - self.cost_used
    return value
  end

  def unit_remaining
    self.quantity - self.quantity_used
  end

  private

  def check_produced
    arr = Assembly.by_firm(firm_id).by_product(id)
    quantity = arr.map(&:produced).compact.sum
    return quantity
  end

  def count_sold
    arr = Revenue.by_firm(firm_id).operating.by_item(id)
    quantity_used = arr.map{ |rev| rev.quantity }.compact.sum
    return quantity_used
  end

  def check_cost_used
    arr = Revenue.by_firm(firm_id).operating.by_item(id)
    cost_used = arr.map{ |rev| rev.item_value }.compact.sum
    return cost_used
  end

  def check_cost_production
    arr = Assembly.by_firm(firm_id).by_product(id)
    total_cost = arr.map{ |assembly|  assembly.total_cost }.compact.sum
    return total_cost
  end

  def check_status
    if check_produced == count_sold
      return 'Habis'
    else
      return 'Tersedia'
    end
  end

  def set_cost_attributes!
    self.status  = 'Tersedia'
  end

  def touch_report
    find_report(IncomeStatement).touch
    # find_report(BalanceSheet).touch
  end

  def update_product
    update(quantity: check_produced, 
         cost: check_cost_production, 
         quantity_used: count_sold, cost_used: check_cost_used,
         status: check_status 
         )
  end

  # def update_cost_remaining
  #   update(cost_remaining: check_cost_remaining)
  # end

end