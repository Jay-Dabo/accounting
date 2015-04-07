class Expendable < ActiveRecord::Base
  belongs_to :spending, foreign_key: 'spending_id'
  belongs_to :firm, foreign_key: 'firm_id'
  has_many   :discards, as: :discardable
  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
  scope :prepaids, -> { where(account_type: 'Prepaids') }
  scope :supplies, -> { where(account_type: 'Supplies') }  
  scope :available, -> { where(perished: false) }

  after_touch :update_item#, :if => :available
  before_create :set_attributes!
  # before_update :check_status
  after_save :touch_reports  


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

  def set_attributes!
    self.value_per_unit = (self.value / self.unit).round
    self.unit_expensed = 0
    self.value_expensed  = 0
  end

  def update_item
    update(unit_expensed: check_unit_expensed, 
           value_expensed: calculate_expense)
  end

  def check_status
    if self.unit_expensed == self.unit
      self.perished = true
    else
      self.perished = false
    end
  end

  def check_unit_expensed
    arr = Discard.by_firm(firm_id).by_item(id)
    expensed = arr.map{ |discard| discard.quantity }.compact.sum
    return expensed
  end

  def calculate_expense
    arr = Discard.by_firm(firm_id).by_item(id)
    expensed = arr.map{ |discard| discard.quantity * discard.discardable.value_per_unit }.compact.sum
    return expensed    
  end

  def touch_reports
    find_report(IncomeStatement).touch
  end

end
