class Expense < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  # has_many :discards, as: :discardable
  validates :item_type, presence: true
  validates :item_name, presence: true
  validates :quantity, presence: true
  validates :cost, presence: true, numericality: true
  validates :firm_id, presence: true

  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id) }
  scope :by_year, ->(year) { where(year: year) }
  scope :operating, -> { where(item_type: ['Marketing', 
        'Salary', 'Utilities', 'General', 'Rent', 'Supplies']) }
  scope :others, -> { where(item_type: ['Misc']) }
  scope :tax, -> { where(item_type: ['Tax']) }
  scope :interest, -> { where(item_type: ['Interest']) }

  # before_save :set_attributes!
  after_touch :update_expense
  after_save :touch_income_statement

  def cost_per_unit
    (self.cost / self.quantity).round
  end

  def date_purchased
    Spending.find_by(firm_id: firm_id, item_name: item_name).date_of_spending
  end
  def year_purchased
    date_purchased.strftime("%Y")
  end

  def related_spendings
    Spending.by_firm(firm_id).expenses.by_name(item_name)
  end

  def find_income_statement
    IncomeStatement.find_by_firm_id_and_year(firm_id, year_purchased)
  end

  private

  def touch_income_statement
    find_income_statement.touch
  end

  def update_expense
    update(cost: check_cost_bought, quantity: check_quantity_bought)
  end

  def check_quantity_bought
    arr = Spending.by_firm(self.firm_id).expenses.by_name(item_name)
    quantity_bought = arr.map{ |spe| spe.quantity }.compact.sum
    return quantity_bought
  end

  def check_cost_bought
    arr = Spending.by_firm(self.firm_id).expenses.by_name(item_name)
    cost_bought = arr.map{ |spe| spe.total_spent }.compact.sum
    return cost_bought
  end
end
