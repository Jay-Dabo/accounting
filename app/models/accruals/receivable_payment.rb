class ReceivablePayment < ActiveRecord::Base
  include GeneralScoping
  belongs_to :firm, foreign_key: 'firm_id'
  belongs_to :revenue, foreign_key: 'revenue_id'

  validates_presence_of :year, :amount
  validates_associated  :firm, :revenue
	
  scope :by_revenue, ->(revenue_id) { where(revenue_id: revenue_id)}
  
  attr_accessor :date, :month

  before_create :set_year!
  after_save :after_effect


  private

  def after_effect
	Revenue.find_by_id_and_firm_id(revenue_id, firm_id).touch
  end

  def set_year!
    self.date_of_payment = DateTime.parse("#{self.year}-#{self.month}-#{self.date}")
    # self.year = self.date_of_payment.strftime("%Y")
  end

end
