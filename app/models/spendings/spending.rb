class Spending < ActiveRecord::Base
  include GeneralScoping
  include Reporting
	belongs_to :firm
  has_many :payable_payments, as: :payable, dependent: :destroy
  has_one :asset, dependent: :destroy
  has_one :expendable, dependent: :destroy
  has_one :merchandise, dependent: :destroy
  has_one :material, dependent: :destroy
  has_one :expense, dependent: :destroy
  accepts_nested_attributes_for :asset, reject_if: :all_blank
  accepts_nested_attributes_for :merchandise, reject_if: :all_blank
  accepts_nested_attributes_for :material, reject_if: :all_blank
  accepts_nested_attributes_for :expense, reject_if: :all_blank
  accepts_nested_attributes_for :expendable, reject_if: :all_blank

  attr_accessor :date, :month

  # unless RAILS.env.test?
    validate do
      if self.spending_type == 'Asset' || self.spending_type == 'Expendable'
        check_value_and_total_spent
      else
        check_cost_and_total_spent
      end
    end
  # end

	# validates :date_of_spending, presence: true
  validates_presence_of :year
  # validates_associated :firm
	validates :spending_type, presence: true
	validates :total_spent, presence: true, numericality: { greater_than: 0 }
  validates_format_of :dp_paid, with: /[0-9]/, :unless => lambda { self.installment == false }
  validates :info, length: { maximum: 200 }

  default_scope { order(date_of_spending: :desc) }
  scope :assets, -> { where(spending_type: 'Asset') }
  scope :merchandises, -> { where(spending_type: 'Merchandise') }
  scope :materials, -> { where(spending_type: 'Material') }
  scope :expenses, -> { where(spending_type: 'Expense') }
  scope :expendables, -> { where(spending_type: 'Expendable') }
  scope :payables, -> { where(installment: true) }

  scope :opex, -> { joins(:expense).merge(Expense.operating) }
  scope :other_expense, -> { joins(:expense).merge(Expense.others) }
  scope :interest_expense, -> { joins(:expense).merge(Expense.interest) }
  scope :tax_expense, -> { joins(:expense).merge(Expense.tax) }

  after_touch :update_values!
  before_create :set_attribute!, :check_installment
  before_update :check_installment
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

  def payable
    if payment_installed == 0
      return 0
    else
      return payment_installed
    end
  end


  private

  def amount_spend_not_balanced
    merchandise.cost != self.total_spent
  end

  def check_value_and_total_spent
    if self.spending_type == 'Asset'
      if asset.value != self.total_spent
        errors.add(:base, "Total Pembayaran dan Konfirmasi Pembayaran Tidak Sama")
      end
    else
      if expendable.value != self.total_spent
        errors.add(:base, "Total Pembayaran dan Konfirmasi Pembayaran Tidak Sama")
      end      
    end
  end

  def check_cost_and_total_spent
    if self.spending_type == 'Merchandise' 
      if merchandise.cost != self.total_spent
        errors.add(:base, "Total Pembayaran dan Konfirmasi Pembayaran Tidak Sama")
      end
    elsif self.spending_type == 'Material'
      if material.cost != self.total_spent
        errors.add(:base, "Total Pembayaran dan Konfirmasi Pembayaran Tidak Sama")
      end
    else
      if expense.cost != total_spent
        errors.add(:base, "Total Pembayaran dan Konfirmasi Pembayaran Tidak Sama")
      end      
    end
  end

  def touch_reports    
    # if self.spending_type == 'Asset'
    # elsif self.spending_type == 'Expendable'
    # elsif self.spending_type == 'Expense'
    # elsif self.spending_type == 'Merchandise'
    # elsif self.spending_type == 'Material'
    # end
    find_report(BalanceSheet).touch
  end
    
  def toggle_installment!
    if self.payable == 0
        return false
      else
        return true
    end
  end

  def set_attribute!
    self.date_of_spending = DateTime.parse("#{self.year}-#{self.month}-#{self.date}")
    # self.year = self.date_of_spending.strftime("%Y")
  end

  def check_installment
    if self.installment == false
      self.dp_paid = self.total_spent
    end
  end

  def update_values!
    update(dp_paid: find_amount_payment, installment: toggle_installment!)
  end

  def find_amount_payment
    arr = PayablePayment.by_firm(firm_id).non_loan_payment.by_payable(id)
    value_paid = arr.map{ |pay| pay.amount }.compact.sum
    value = self.dp_paid + value_paid
    return value
  end

end
