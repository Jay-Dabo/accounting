class Spending < ActiveRecord::Base
  include ActiveModel::Dirty
  
	belongs_to :firm
  has_one :asset
  has_many :merchandises, inverse_of: :spending
  has_one :expense
  accepts_nested_attributes_for :asset
  accepts_nested_attributes_for :merchandises, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :expense

	validates :date_of_spending, presence: true
  validates :firm_id, presence: true, numericality: { only_integer: true }
	validates :spending_type, presence: true
	validates :total_spent, presence: true, numericality: { greater_than: 0 }
  validates :dp_paid, numericality: true
  validates :info, length: { maximum: 200 }

  default_scope { order(date_of_spending: :asc) }
	scope :assets, -> { where(spending_type: 'Asset') }
  scope :merchandises, -> { where(spending_type: 'Inventory') }
	scope :expenses, -> { where(spending_type: 'Expense') }

  after_save :add_spending_credit!

  def find_balance_sheet
    BalanceSheet.find_by_firm_id_and_year(firm_id, date_of_spending.strftime("%Y"))
  end


  private
    
  def add_spending_credit!
    if self.installment == true 
      determine_payable
      cash_paid_with_installment
    else
      cash_paid_only
    end
  end

  def cash_paid_only
    if self.total_spent_was == nil
      find_balance_sheet.decrement!(:cash, self.total_spent)
    else
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
    else
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
    else
      if self.difference_in_paid < self.difference_in_total
        find_balance_sheet.increment!(:payables, self.difference_in_total - self.difference_in_paid)
      elsif self.difference_in_paid > self.difference_in_total
        find_balance_sheet.decrement!(:payables, self.difference_in_paid - self.difference_in_total)
      end
    end
  end

  def payment_installed
    self.total_spent - self.dp_paid
  end

  def payment_installed_was
    self.total_spent_was - self.dp_paid_was
  end

  def difference_in_total
    abs(self.total_spent - self.total_spent_was)
  end

  def difference_in_paid
    abs(self.dp_paid - self.dp_paid_was)
  end

end
