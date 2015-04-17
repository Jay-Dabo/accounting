class Discard < ActiveRecord::Base
  belongs_to :firm, foreign_key: 'firm_id'
  belongs_to :discardable, polymorphic: true
  validates_associated :firm

  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
  scope :by_year, ->(year) { where(year: year)}
  scope :by_item, ->(item_id) { where(discardable_id: item_id)}
  scope :supplies, -> { where(discardable_type: 'Supply') }
  scope :prepaids, -> { where(discardable_type: 'Prepaid') }
  scope :opex, -> { where(discardable_type: ['Prepaid', 'Supply']) }

  attr_accessor :date, :month
  
  # after_touch :update_values!
  before_create :set_attributes!
  after_save :touch_reports


  def find_report(book)
    book.find_by_firm_id_and_year(firm_id, year)
  end

  def find_item(table)
    table.find_by_id_and_firm_id(discardable_id, firm_id)
  end  

  def find_expendable
    Expendable.find_by_id_and_firm_id(discardable_id, firm_id)
  end

  private

  def set_attributes!
    self.date_of_write_off = DateTime.parse("#{self.year}-#{self.month}-#{self.date}")
  	# self.year = self.date_of_write_off.strftime("%Y")
  end

  def touch_reports
    # if self.discardable_type == ['Supply', 'Prepaid']
    find_item(Expendable).touch
    # end
  end

end
