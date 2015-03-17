class Merchandise < ActiveRecord::Base
  monetize :cost
  monetize :price
  belongs_to :spending, inverse_of: :merchandises, foreign_key: 'spending_id'
  belongs_to :firm, inverse_of: :merchandises, foreign_key: 'firm_id'
  has_many :revenues, as: :item
  validates_associated :spending
  validates :merch_name, presence: true
  validates :quantity, presence: true, numericality: true
  validates :cost, presence: true, numericality: true
  validates :price, presence: true
  validates :firm_id, presence: true, numericality: { only_integer: true }

  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
  scope :getting_sold, -> { where('cost_sold > ?', 0) } 
  
  after_touch :update_merchandise
  before_create :set_cost_attributes!
  before_update :check_status
  after_save :touch_balance_sheet


  def set_cost_attributes!
    self.cost_sold = 0
    self.cost_remaining = self.cost
    self.cost_per_unit = cost_per_unit
    self.quantity_sold = 0
    self.status  = 'Utuh'
  end

  def cost_per_unit
    (self.cost / self.quantity).round
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

  def merch_code
    date = self.spending.date_of_spending.strftime("%d%m%Y")
    name = self.merch_name
    number = self.id

    return "#{name}-#{date}-#{number}"    
  end

  def quantity_remaining
    self.quantity - self.quantity_sold
  end

  def check_quantity
    arr = Revenue.by_firm(self.firm_id).operating.by_item(self.id)
    quantity_sold = arr.map(&:quantity).compact.sum
    return quantity_sold
  end

  def check_cost_remaining
    arr = Revenue.by_firm(self.firm_id).operating.by_item(self.id)
    quantity_sold = arr.map{ |rev| rev['quantity']}.compact.sum
    cost_sold = quantity_sold * self.cost_per_unit
    cost_remaining = self.cost - cost_sold
    return cost_remaining
  end

  def check_cost_sold
    arr = Revenue.by_firm(self.firm_id).operating.by_item(self.id)
    quantity_sold = arr.map{ |rev| rev['quantity']}.compact.sum
    cost_sold = quantity_sold * self.cost_per_unit
    return cost_sold
  end

  def check_status
    if self.quantity_sold == self.quantity
      self.status = 'Terjual Habis'
    elsif self.quantity_remaining > 0
      self.status = 'Belum Habis'
    else
      self.status = 'Utuh'
    end
  end


  private

  def touch_balance_sheet
    find_income_statement.touch
    # find_balance_sheet.touch
  end

  def update_merchandise
    update(quantity_sold: check_quantity, cost_remaining: check_cost_remaining,
           cost_sold: check_cost_sold)
  end
end
