class Merchandise < ActiveRecord::Base

  belongs_to :spending, foreign_key: 'spending_id'
  belongs_to :firm, foreign_key: 'firm_id'
  has_many :revenues, as: :item
  validates_associated :spending, on: :create
  validates :merch_name, presence: true
  validates :quantity, presence: true, numericality: true
  validates :cost, presence: true, numericality: true
  validates :firm_id, presence: true
  validates :spending_id, presence: true, on: :update

  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
  scope :by_name, ->(name) { where(merch_name: name) }
  scope :getting_sold, -> { where('cost_sold > ?', 0) } 
  scope :has_payable, -> { joins(:spending).group(:id).merge(Spending.payables) }
  scope :available, -> { where(status: ['Utuh', 'Belum Habis']) }
  scope :in_stock, -> { where('quantity > quantity_sold') }

  after_touch :update_merchandise
  before_create :default_on_create
  before_save :set_cost_attributes!
  # before_update :check_status
  after_save :touch_report


  def cost_per_unit
    (self.cost / self.quantity).round
  end
  
  def cost_left
    self.cost - self.cost_sold
  end

  def date_purchased
    Spending.find_by_firm_id_and_id(firm_id, spending_id).date_of_spending
  end

  def year_purchased
    date_purchased.strftime("%Y")
  end

  def current_year
    Date.today.year
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

  def check_quantity_sold
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
    check_quantity_sold
    if quantity_sold == self.quantity
      return 'Kosong'
    elsif self.quantity_remaining > 0
      return 'Belum Habis'
    else
      return 'Utuh'
    end
  end



  private

  def set_cost_attributes!
      self.cost_per_unit = cost_per_unit
  end

  def default_on_create
    self.cost_remaining = self.cost
    self.cost_sold = 0
    self.quantity_sold = 0
    self.status  = 'Utuh'
  end

  def touch_report
    find_income_statement.touch
  end

  def update_merchandise
    update(quantity_sold: check_quantity_sold, 
           cost_remaining: check_cost_remaining,
           cost_sold: check_cost_sold, status: check_status)
  end
end
