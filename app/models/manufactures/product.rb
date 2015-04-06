class Product < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  has_many :revenues, as: :item

  validates_associated :firm
  validates :product_name, presence: true
  # validates :cost, presence: true, numericality: true
  # validates :firm_id, presence: true, numericality: { only_integer: true }


  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}

  after_touch :update_product
  # before_save :update_cost_remaining
  after_save :touch_report

  def year_purchased
    Date.today.year
  end

  def find_report(report)
    report.find_by_firm_id_and_year(firm_id, year_purchased)
  end 

  def cost_per_unit
    (self.cost / self.quantity_produced).round(0)
  end


  private

  def check_produced
    arr = Assembly.by_firm(firm_id).by_product(id)
    quantity_produced = arr.map(&:produced).compact.sum
    return quantity_produced
  end

  def count_sold
  	arr = Revenue.by_firm(firm_id).operating.by_item(id)
  	quantity_sold = arr.map{ |rev| rev['quantity']}.compact.sum
  	value = quantity_sold
  	return value
  end

  def check_cost_sold
    arr = Revenue.by_firm(firm_id).operating.by_item(id)
    quantity_sold = arr.map{ |rev| rev['quantity']}.compact.sum
    cost_sold = quantity_sold * self.cost_per_unit
    return cost_sold
  end

  def check_cost_production
	  arr = Assembly.by_firm(firm_id).by_product(id)
    total_cost = arr.map{ |assembly|  assembly.total_cost }.compact.sum
    return total_cost
  end

  def check_cost_remaining
  	value = self.cost - self.cost_sold
  	return value
  end

  def check_status
    if self.quantity_sold == self.quantity_produced
      self.status = 'Habis'
    else
      self.status = 'Tersedia'
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
    update(quantity_produced: check_produced, 
    	   cost: check_cost_production, 
    	   quantity_sold: count_sold, cost_sold: check_cost_sold 
    	   )
  end

  def update_cost_remaining
    update(cost_remaining: check_cost_remaining)
  end

end