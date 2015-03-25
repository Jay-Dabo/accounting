class ReceivablePayment < ActiveRecord::Base
	belongs_to :firm, foreign_key: 'firm_id'
	belongs_to :revenue, foreign_key: 'revenue_id'

	validates_presence_of :amount, :date_of_payment
    validates_associated  :firm, :revenue
	
	scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
	scope :by_revenue, ->(revenue_id) { where(revenue_id: revenue_id)}
  
    after_save :after_effect



	private

	def after_effect
		Revenue.find_by_id_and_firm_id(revenue_id, firm_id).touch
	end

end
