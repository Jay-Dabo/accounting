class OtherRevenue < ActiveRecord::Base	
  include GeneralScoping
  belongs_to :firm
  validates_associated :firm
  validates_presence_of :item_name, :total_earned
  validates :total_earned, numericality: { greater_than: 0 }
  validates_format_of :dp_received, with: /[0-9]/, :unless => lambda { self.installment == false }

  attr_accessor :date, :month

  default_scope { order(date_of_revenue: :asc) }
  # scope :others, -> { where(item_type: 'Asset') }
  scope :receivables, -> { where(installment: true) }
  scope :full, -> { where(installment: false) }
  scope :by_year, ->(year) { where(year: year) }

  after_touch :update_values!
  # before_create :set_attributes!
  before_save :set_attributes!, :check_installment
  after_save :touch_reports

  def invoice_number
    date = self.date_of_revenue.strftime("%Y%m%d")
    number = self.id

    return "#{number}-#{type}-#{date}"
  end

  def receivable
	  self.total_earned - self.dp_received
  end


  def find_report(name)
    name.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
  end

  private

  def touch_reports
    find_report(IncomeStatement).touch
    find_report(BalanceSheet).touch
  end

  def set_attributes!
    # self.year = self.date_of_revenue.strftime("%Y")
    self.date_of_revenue = DateTime.parse("#{self.year}-#{self.month}-#{self.date}")
  end

  def toggle_installment!
    if self.receivable == 0
      return false
    else
      return true
    end
  end
	
  def check_installment
    if self.installment == false
      self.dp_received = self.total_earned
    end
  end


  def update_values!
    update(dp_received: find_amount_payment, 
           installment: toggle_installment!)
  end

  def find_amount_payment
    arr = ReceivablePayment.by_firm(firm_id).by_revenue(id)
    value_paid = arr.map{ |pay| pay.amount }.compact.sum
    value = self.dp_received + value_paid
    return value
  end
	
end
