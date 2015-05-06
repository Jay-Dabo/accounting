class Work < ActiveRecord::Base
  include GeneralScoping
  belongs_to :firm, foreign_key: 'firm_id'
  has_many :revenues, as: :item
  validates_associated :firm

  scope :by_name, ->(name) { where(work_name: name) }
  scope :available, -> { where(deleted: false) }
  
  # after_touch :touch_report#, :update_merchandise
  # after_save :touch_balance_sheet

  private

  def touch_report
    find_income_statement.touch
    # find_balance_sheet.touch
  end
  
end
