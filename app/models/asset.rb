class Asset < ActiveRecord::Base
	include ActiveModel::Dirty

  monetize :value
	belongs_to :spending, inverse_of: :asset, foreign_key: 'spending_id'
  belongs_to :firm, foreign_key: 'firm_id'
	validates_associated :spending
  validates :asset_type, presence: true
  validates :unit, presence: true, numericality: true
  validates :measurement, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :value, presence: true, numericality: true
  validates :useful_life, numericality: true
  validates :firm_id, presence: true, numericality: { only_integer: true }	
  
	scope :prepaids, -> { where(asset_type: 'Prepaid') }
	scope :other_current, -> { where(asset_type: 'OtherCurrentAsset') }
	scope :equipments, -> { where(asset_type: 'Equipment') }
	scope :plants, -> { where(asset_type: 'Plant') }
	scope :buildings, -> { where(asset_type: 'Property') }

	after_save :into_balance_sheet

  def asset_code
    name = self.asset_name
    type = self.asset_type
    number = self.id

    return "#{name}-#{type}-#{number}"    
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

  def apply_depreciation
    if self.asset_type == 'Equipment' || self.asset_type == 'Plant'
      depr = self.value / self.useful_life

      self.increment!(:depreciation, depr)
      self.decrement!(:value, self.depr)
      find_income_statement.increment!(:operating_expense, self.depr)
      find_balance_sheet.decrement!(:fixed_assets, self.depr)
    end    
  end

  private

  def into_balance_sheet
    if self.asset_type == "Prepaid" || self.asset_type == "OtherCurrentAsset"
      add_other_current_assets!
    else
      add_fixed_assets!
    end
  end

	# Manage Fixed Assets: PPE
  def add_fixed_assets!
    if self.value_was == nil
      find_balance_sheet.increment!(:fixed_assets, self.value)
    else
      if self.value != self.value_was
        if self.value < self.value_was
          find_balance_sheet.decrement!(:fixed_assets, self.value_was - self.value)
        elsif self.value > self.value_was
          find_balance_sheet.increment!(:fixed_assets, self.value - self.value_was)
        end
      end
    end
  end


  def add_other_current_assets!
    if self.value_was == nil
      find_balance_sheet.increment!(:other_current_assets, self.value)
    elsif self.value != self.value_was
      if self.value < self.value_was
        find_balance_sheet.decrement!(:other_current_assets, self.value_was - self.value)
      elsif self.value > self.value_was
        find_balance_sheet.increment!(:other_current_assets, self.value - self.value_was)
      end
    end
  end


end
