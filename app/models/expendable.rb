class Expendable < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  has_many   :discards, as: :discardable
  validates_associated :firm, on: :create
  validates :cost, presence: true, numericality: true
  validates :quantity, presence: true, numericality: true
  validates :measurement, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }  
  
  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id) }
  scope :prepaids, -> { where(item_type: 'Prepaids') }
  scope :supplies, -> { where(item_type: 'Supplies') }
  scope :by_name, ->(name) { where(item_name: name) }  
  scope :available, -> { where(perished: false) }

  after_touch :update_item#, :if => :available
  after_save :touch_reports  

  def code
    name = self.item_name
    date = date_purchased
    return "#{name}, dibeli pada tgl #{date}"
  end

  def cost_per_quantity
    (self.cost / self.quantity).round
  end

  def date_purchased
	  Spending.find_by(firm_id: firm_id, item_name: item_name).date_of_spending
  end

  def year_purchased
	 date_purchased.strftime("%Y")
  end

  def related_spendings
    Spending.by_firm(firm_id).expendables.by_name(item_name)
  end

  def find_report(book)
    book.find_by_firm_id_and_year(firm_id, year_purchased)
  end

  def quantity_remaining
    self.quantity - self.quantity_used
  end

  def cost_remaining
    self.cost - self.cost_used
  end

  private

  def update_item
    update(quantity_used: check_quantity_used, perished: check_status, 
           cost_used: calculate_expense, quantity: check_quantity_bought,
           cost: check_cost_bought)
  end

  def check_status
    check_quantity_used
    if quantity_used == self.quantity
      return true
    else
      return false
    end
  end

  def check_quantity_used
    arr = Discard.by_firm(firm_id).by_item(id)
    quantity_used = arr.map{ |discard| discard.quantity }.compact.sum
    return quantity_used
  end

  def calculate_expense
    arr = Discard.by_firm(firm_id).by_item(id)
    # expensed = arr.map{ |discard| discard.quantity * discard.discardable.cost_per_quantity }.compact.sum
    expensed = arr.map{ |discard| discard.item_value }.compact.sum
    return expensed    
  end

  def check_quantity_bought
    arr = Spending.by_firm(self.firm_id).expendables.by_name(item_name)
    quantity_bought = arr.map{ |spe| spe.quantity }.compact.sum
    return quantity_bought
  end

  def check_cost_bought
    arr = Spending.by_firm(self.firm_id).expendables.by_name(item_name)
    cost_bought = arr.map{ |spe| spe.total_spent }.compact.sum
    return cost_bought
  end

  def touch_reports
    find_report(IncomeStatement).touch
  end

end
