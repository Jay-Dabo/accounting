class Spending < ActiveRecord::Base
  include ActiveModel::Dirty


	belongs_to :firm
  has_many :payable_payments
  has_one :asset
  has_many :merchandises, inverse_of: :spending
  has_one :expense
  accepts_nested_attributes_for :asset#, reject_if: :amount_spend_not_balanced
  accepts_nested_attributes_for :merchandises, reject_if: :all_blank, allow_destroy: true
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
  scope :merchandises, -> { where(spending_type: 'Inventory') }
	scope :expenses, -> { where(spending_type: 'Expense') }
  scope :payables, -> { where(installment: true) }
  scope :full, -> { where(installment: false) }

  # validate :check_amount_spend!
  # after_save :add_spending_credit!
  after_save :touch_reports

  def payment_installed
    self.total_spent - self.dp_paid
  end

  def payment_installed_was
    self.total_spent_was - self.dp_paid_was
  end

  def difference_in_total
    (self.total_spent - self.total_spent_was).abs
  end

  def difference_in_paid
    (self.dp_paid - self.dp_paid_was).abs
  end

  def invoice_number
    date = self.date_of_spending.strftime("%Y%m%d")
    type = self.spending_type
    number = self.id

    return "#{date}-#{type}-#{number}"
  end

  def find_balance_sheet
    BalanceSheet.find_by_firm_id_and_year(firm_id, date_of_spending.strftime("%Y"))
  end

  def find_asset
    Asset.find_by_firm_id_and_spending_id(firm_id, self)
  end

  def payable
    if self.dp_paid == nil
      return nil
    else
      return self.total_spent - self.dp_paid
    end
  end


  private

  def touch_reports
    find_balance_sheet.touch
  end
    
  def add_spending_credit!
    if self.installment == true 
      if self.payable == 0
        self.update_attribute(:installment, false)
      else
        determine_payable        
      end
    end
  end

  def cash_paid_only
    if self.total_spent_was == nil
      find_balance_sheet.decrement!(:cash, self.total_spent)
    elsif self.total_spent != self.total_spent_was
      if self.total_spent < total_spent_was
        find_balance_sheet.increment!(:cash, self.total_spent_was - self.total_spent)
      else
        find_balance_sheet.decrement!(:cash, self.total_spent - self.total_spent_was)
      end
    end
  end

  def cash_paid_with_installment
    if self.total_spent_was == nil
      find_balance_sheet.decrement!(:cash, self.dp_paid)
    elsif self.dp_paid != self.dp_paid_was
      if self.dp_paid < dp_paid_was
        find_balance_sheet.increment!(:cash, self.dp_paid_was - self.dp_paid)
      else
        find_balance_sheet.decrement!(:cash, self.dp_paid - self.dp_paid_was)
      end
    end
  end

  def determine_payable
    if self.total_spent_was == nil
      find_balance_sheet.increment!(:payables, payment_installed)
    elsif self.dp_paid != self.dp_paid_was || self.total_spent != self.total_spent_was
      if self.difference_in_paid < self.difference_in_total
        find_balance_sheet.increment!(:payables, self.difference_in_total - self.difference_in_paid)
      elsif self.difference_in_paid > self.difference_in_total
        find_balance_sheet.decrement!(:payables, self.difference_in_paid - self.difference_in_total)
      end
    end
  end



end
