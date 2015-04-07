module GeneralScoping
	extend ActiveSupport::Concern
	included do
  		scope :by_firm, ->(firm_id) { where(:firm_id => firm_id) }
  		scope :by_year, ->(year) { where(year: year) }
	end
end