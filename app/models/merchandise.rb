class Merchandise < ActiveRecord::Base
  include ActiveModel::Dirty

  belongs_to :spending, inverse_of: :merchandises, foreign_key: 'spending_id'
  belongs_to :firm, inverse_of: :merchandises, foreign_key: 'firm_id'
  validates_associated :spending
  validates :merch_name, presence: true
  validates :quantity, presence: true, numericality: true
  validates :cost, presence: true, numericality: true
  validates :price, presence: true
  validates :firm_id, presence: true, numericality: { only_integer: true }

  
  after_save :add_inventories!

  def cost_per_unit
    (self.cost / self.quantity).round
  end
  
  def date_purchased
    Spending.find_by_firm_id_and_id(self.firm_id, self.spending_id).date_of_spending
  end

  def year_purchased
    date_purchased.strftime("%Y")
  end

  def find_balance_sheet
    BalanceSheet.find_by_firm_id_and_year(firm_id, year_purchased)
  end

  def find_income_statement
    IncomeStatement.find_by_firm_id_and_year(firm_id, year_purchased)
  end


  private

  def add_inventories!
    if self.cost != self.cost_was
      if self.cost < self.cost_was
        find_balance_sheet.decrement!(:inventories, self.cost_was - self.cost)
      elsif self.cost > self.cost_was
        find_balance_sheet.increment!(:inventories, self.cost - self.cost_was)
      end
    end
  end


end
