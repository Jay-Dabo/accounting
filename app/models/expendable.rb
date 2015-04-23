class Expendable < ActiveRecord::Base
  belongs_to :spending, foreign_key: 'spending_id'
  belongs_to :firm, foreign_key: 'firm_id'
  has_many   :discards, as: :discardable
  validates_associated :spending, on: :create
  validates :value, presence: true, numericality: true
  validates :unit, presence: true, numericality: true
  validates :measurement, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }  
  validates :spending_id, presence: true, on: :update
  
  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id) }
  scope :prepaids, -> { where(account_type: 'Prepaids') }
  scope :supplies, -> { where(account_type: 'Supplies') }
  scope :by_name, ->(name) { where(item_name: name) }  
  scope :available, -> { where(perished: false) }

  after_touch :update_item#, :if => :available
  before_create :default_on_create
  before_save :set_attributes!
  after_save :touch_reports  

  def code
    name = self.item_name
    date = date_purchased
    return "#{name}, dibeli pada tgl #{date}"
  end

  def cost_per_unit
    (self.value / self.unit).round
  end

  def date_purchased
	  Spending.find_by_firm_id_and_id(self.firm_id, self.spending_id).date_of_spending
  end

  def year_purchased
	date_purchased.strftime("%Y")
  end

  def find_report(book)
    book.find_by_firm_id_and_year(firm_id, year_purchased)
  end

  def unit_remaining
    self.unit - self.unit_expensed
  end

  def value_remaining
    self.value - self.value_expensed
  end

  private

  def default_on_create
    self.unit_expensed = 0
    self.value_expensed  = 0
  end

  def set_attributes!
    self.value_per_unit = (self.value / self.unit).round
  end

  def update_item
    update(unit_expensed: check_unit_expensed, 
           value_expensed: calculate_expense, perished: check_status)
  end

  def check_status
    check_unit_expensed
    if unit_expensed == self.unit
      return true
    else
      return false
    end
  end

  def check_unit_expensed
    arr = Discard.by_firm(firm_id).by_item(id)
    unit_expensed = arr.map{ |discard| discard.quantity }.compact.sum
    return unit_expensed
  end

  def calculate_expense
    arr = Discard.by_firm(firm_id).by_item(id)
    # expensed = arr.map{ |discard| discard.quantity * discard.discardable.value_per_unit }.compact.sum
    expensed = arr.map{ |discard| discard.item_value }.compact.sum
    return expensed    
  end

  def touch_reports
    find_report(IncomeStatement).touch
  end

end
