module Reporting
	extend ActiveSupport::Concern
	included do

	  def find_report(book)
	    book.find_by_firm_id_and_year(firm_id, year)
	  end

	end
end