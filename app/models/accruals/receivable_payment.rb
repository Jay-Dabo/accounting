class ReceivablePayment < ActiveRecord::Base
	include ActiveModel::Dirty
	belongs_to :firm, foreign_key: 'firm_id'
	belongs_to :revenue, foreign_key: 'revenue_id'

	validates_presence_of :amount
    validates_associated  :firm, :revenue
	
	scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
	scope :by_revenue, ->(revenue_id) { where(revenue_id: revenue_id)}
  
    after_save :create_receivable_reduction

	def find_revenue
		Revenue.find_by_firm_id_and_id(self.firm_id, self.revenue_id)
	end


	private

	def create_receivable_reduction
		if self.amount_was == nil
			find_revenue.increment!(:dp_received, self.amount)
		elsif self.amount != self.amount_was
			if self.amount < self.amount_was
				find_revenue.decrement!(:dp_received, self.amount_was - self.amount)
			else
				find_revenue.increment!(:dp_received, self.amount - self.amount_was)
			end
		end
		find_revenue.touch
	end

	# def touch_related_revenue
	# 	find_revenue.touch
	# end

end
