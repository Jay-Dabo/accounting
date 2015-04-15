class Work < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  has_many :revenues, as: :item
  validates_associated :firm

  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
  scope :by_name, ->(name) { where(work_name: name) }

  # after_touch :touch_report#, :update_merchandise
  # after_save :touch_balance_sheet

  private

  def touch_report
    find_income_statement.touch
    # find_balance_sheet.touch
  end
  
end
