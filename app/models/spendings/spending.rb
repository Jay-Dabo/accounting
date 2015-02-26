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

	scope :assets, -> { where(spending_type: 'Asset') }
  scope :merchandises, -> { where(spending_type: 'Inventory') }
	scope :expense, -> { where(spending_type: 'Expense') }

  after_save :add_spending_credit!

  def find_balance_sheet
    BalanceSheet.find_by_firm_id_and_year(firm_id, date_of_spending.strftime("%Y"))
  end

    
  def add_spending_credit!
    if self.installment == true
      find_balance_sheet.decrement!(:cash, self.dp_paid)
      find_balance_sheet.increment!(:payables, self.total_spent - self.down_payment)
    else
      find_balance_sheet.decrement!(:cash, self.total_spent)      
    end
  end

end
