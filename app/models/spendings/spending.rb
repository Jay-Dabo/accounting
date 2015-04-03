class Spending < ActiveRecord::Base
	belongs_to :firm
  has_many :payable_payments, as: :payable
  has_one :asset
  has_many :merchandises, inverse_of: :spending
  has_many :materials, inverse_of: :spending
  has_one :expense
  accepts_nested_attributes_for :asset#, reject_if: :amount_spend_not_balanced
  accepts_nested_attributes_for :merchandises, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :materials, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :expense

	validates :date_of_spending, presence: true
  validates :firm_id, presence: true, numericality: { only_integer: true }
	validates :spending_type, presence: true
	validates :total_spent, presence: true, numericality: { greater_than: 0 }
  validates_format_of :dp_paid, with: /[0-9]/, :unless => lambda { self.installment == false }
  validates :info, length: { maximum: 200 }

  default_scope { order(date_of_spending: :asc) }
  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :assets, -> { where(spending_type: 'Asset') }
  scope :merchandises, -> { where(spending_type: 'Merchandise') }
	scope :expenses, -> { where(spending_type: 'Expense') }
  scope :payables, -> { where(installment: true) }
  scope :full, -> { where(installment: false) }
  scope :by_year, ->(year) { where(year: year) }
  scope :opex, -> { joins(:expense).merge(Expense.operating) }
  scope :other_expense, -> { joins(:expense).merge(Expense.others) }
  scope :interest_expense, -> { joins(:expense).merge(Expense.interest) }
  scope :tax_expense, -> { joins(:expense).merge(Expense.tax) }

  # validate :check_amount_spend!
  after_touch :update_values!
  before_create :set_attribute!
  before_save :toggle_installment!
  after_save :touch_reports

  def payment_installed
    self.total_spent - self.dp_paid
  end

  def invoice_number
    date = self.date_of_spending.strftime("%Y%m%d")
    type = self.spending_type
    number = self.id

    return "#{date}-#{type}-#{number}"
  end

  def find_report(model)
    model.find_by_firm_id_and_year(firm_id, date_of_spending.strftime("%Y"))
  end

  def find_asset
    Asset.find_by_firm_id_and_spending_id(firm_id, self)
  end

  def payable
    if self.dp_paid == nil
      return 0
    else
      return self.total_spent - self.dp_paid
    end
  end


  private

  def touch_reports    
    find_report(BalanceSheet).touch
  end
    
  def toggle_installment!
    if self.installment == true && self.payable == 0
        self.update_attribute(:installment, false)
    end
  end

  def set_attribute!
    self.year = self.date_of_spending.strftime("%Y")
    if self.installment == false
      self.dp_paid = self.total_spent
    end
  end

  def update_values!
    update(dp_paid: find_amount_payment)
  end

  def find_amount_payment
    arr = PayablePayment.by_firm(firm_id).non_loan_payment.by_payable(id)
    value_paid = arr.map{ |pay| pay.amount }.compact.sum
    value = self.dp_paid + value_paid
    return value
  end

end
