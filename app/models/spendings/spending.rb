class Spending < ActiveRecord::Base
  include GeneralScoping
  include Reporting
	belongs_to :firm
  has_many :payable_payments, as: :payable, dependent: :destroy

  store :item_details, accessors: [
    :item_type, :measurement, :perishable
    ]

  attr_accessor :date, :month

	# validates :date_of_spending, presence: true
  validates_presence_of :year
  validates_associated :firm
	validates :spending_type, presence: true
	validates :total_spent, presence: true, numericality: { greater_than: 0 }
  validates_format_of :dp_paid, with: /[0-9]/, :unless => lambda { self.installment == false }
  validates :info, length: { maximum: 200 }

  default_scope { order(date_of_spending: :desc) }
  scope :by_name, ->(item_name) { where(item_name: item_name) }
  scope :assets, -> { where(spending_type: 'Asset') }
  scope :merchandises, -> { where(spending_type: 'Merchandise') }
  scope :materials, -> { where(spending_type: 'Material') }
  scope :expenses, -> { where(spending_type: 'Expense') }
  scope :expendables, -> { where(spending_type: 'Expendable') }
  scope :payables, -> { where(installment: true) }
  scope :fifteen_days, -> { where("maturity < ?", 15.days.from_now)  }

  after_touch :update_values!
  before_save :set_attribute!, :check_installment
  # before_update :set_attribute!, :check_installment
  after_save :touch_reports

  def find_current_expenses
    Spending.by_firm(firm_id).expenses.by_year(year)
  end

  def find_current_opex
    self.find_current_expenses.map do |spe|
      
    end
  end

  def payment_installed
    self.total_spent - self.dp_paid - self.payment_balance
  end

  def invoice_number
    date = self.date_of_spending.strftime("%Y%m%d")
    type = self.spending_type
    number = self.id

    return "#{date}-#{type}-#{number}"
  end

  def payable
    if payment_installed == 0
      return 0
    else
      return payment_installed
    end
  end

  def for_asset?
    if self.spending_type == 'Asset'
      return true
    end
  end

  def for_merchandise?
    if self.spending_type == 'Merchandise'
      return true
    end
  end

  def for_expendable?
    if self.spending_type == 'Expendable'
      return true
    end
  end

  def for_material?
    if self.spending_type == 'Material'
      return true
    end
  end

  def for_expense?
    if self.spending_type == 'Expense'
      return true
    end
  end


  private

  def touch_reports    
    find_report(BalanceSheet).touch
    if for_merchandise? && find_item(Merchandise)
      find_item(Merchandise).touch
    elsif for_material? && find_item(Material)
      find_item(Material).touch
    elsif for_expense? && find_item(Expense)
      find_item(Expense).touch
    elsif for_expendable? && find_item(Expendable)
      find_item(Expendable).touch
    elsif for_asset? && find_item(Asset)
      find_item(Asset).touch
      # Asset.find_by(item_name: self.item_name, firm_id: self.firm_id).touch
      # Asset.by_firm(firm_id).by_name(item_name).first.touch
    end
  end

  def find_item(name)
    name.find_by(item_name: item_name, firm_id: firm_id)
  end

  def toggle_installment!
    if self.payable == 0
        return false
      else
        return true
    end
  end

  def set_attribute!
    unless date == nil || month == nil
      self.date_of_spending = DateTime.parse("#{self.year}-#{self.month}-#{self.date}")
      # self.year = self.date_of_spending.strftime("%Y")
    end
    self.item_name = self.item_name.gsub(/ /, '_').camelize
    self.measurement = self.measurement.gsub(/ /, '_').camelize
  end

  def check_installment
    if self.installment == false
      self.dp_paid = self.total_spent
    end
  end

  def update_values!
    update(payment_balance: find_amount_payment, 
           installment: toggle_installment!)
  end

  def find_amount_payment
    arr = PayablePayment.by_firm(firm_id).non_loan_payment.by_payable(id)
    value_paid = arr.map{ |pay| pay.amount }.compact.sum
    return value_paid
  end

end
