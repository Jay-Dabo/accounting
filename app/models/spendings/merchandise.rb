class Merchandise < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  has_many :revenues, as: :item
  # validates_associated :spending, on: :create
  validates :item_name, presence: true
  validates :quantity, presence: true, numericality: true
  validates :cost, presence: true, numericality: true
  validates :firm_id, presence: true
  # validates :spending_id, presence: true, on: :update

  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
  scope :by_name, ->(name) { where(item_name: name) }
  scope :getting_sold, -> { where('cost_used > ?', 0) } 
  scope :has_payable, -> { joins(:spending).group(:id).merge(Spending.payables) }
  scope :available, -> { where(status: ['Utuh', 'Belum Habis']) }
  scope :in_stock, -> { where('quantity > quantity_used') }

  after_touch :update_merchandise
  before_create :default_on_create
  # before_save :set_cost_attributes!
  after_save :touch_report


  def cost_per_unit
    (self.cost / self.quantity).round
  end
  
  def cost_remaining
    self.cost - self.cost_used
  end

  def quantity_remaining
    self.quantity - self.quantity_used
  end

  def date_purchased
    Spending.find_by(firm_id: firm_id, item_name: item_name).date_of_spending
  end

  def year_purchased
    date_purchased.strftime("%Y")
    # Date.today.year
  end

  # def current_year
  #   Date.today.year
  # end

  def related_spendings
    Spending.by_firm(firm_id).merchandises.by_name(item_name)
  end

  def related_earnings
    Revenue.by_firm(firm_id).merchandising.by_item(id)
  end  


  def find_income_statement
    IncomeStatement.find_by_firm_id_and_year(firm_id, year_purchased)
  end

  def merch_code
    date = self.year_purchased
    name = self.item_name
    number = self.id

    return "#{name}-#{date}-#{number}"    
  end

  def check_quantity_used
    arr = Revenue.by_firm(self.firm_id).operating.by_item(self.id)
    quantity_used = arr.map(&:quantity).compact.sum
    return quantity_used
  end

  def check_cost_used
    arr = Revenue.by_firm(self.firm_id).operating.by_item(self.id)
    quantity_used = arr.map{ |rev| rev.quantity }.compact.sum
    cost_used = quantity_used * self.cost_per_unit
    return cost_used
  end

  def check_quantity_bought
    arr = Spending.by_firm(self.firm_id).merchandises.by_name(self.item_name)
    quantity_bought = arr.map{ |spe| spe.quantity }.compact.sum
    return quantity_bought
  end

  def check_cost_bought
    arr = Spending.by_firm(self.firm_id).merchandises.by_name(self.item_name)
    cost_bought = arr.map{ |spe| spe.total_spent }.compact.sum
    return cost_bought
  end

  def check_status
    check_quantity_used
    if quantity_used == self.quantity
      return 'Kosong'
    elsif self.quantity_remaining > 0
      return 'Belum Habis'
    else
      return 'Utuh'
    end
  end

  private

  def set_cost_attributes!
    # self.cost_per_unit = cost_per_unit
  end

  def default_on_create
    self.status  = 'Utuh'
  end

  def touch_report
    find_income_statement.touch
  end

  def update_merchandise
    update(cost: check_cost_bought, quantity: check_quantity_bought,
           quantity_used: check_quantity_used, 
           cost_used: check_cost_used, status: check_status)
  end
end
