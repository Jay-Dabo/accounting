module FirmsHelper

	def business_type_options
		[ ["Jual-Beli", "Trading"], ["Jasa", "Service"],
     	["Manufaktur", "Manufacture"] ]		
	end

	def industry_options
		[ ["Makanan & Minuman", "Makanan & Minuman"], 
		      ["Pakaian", "Pakaian"], ["Teknologi", "Teknologi"], 
		      ["Elektronik", "Elektronik"], ["Material", "Material"], 
		      ["Konstruksi", "Konstruksi"], ["Kreatif", "Kreatif"], 
		      ["Lain-lain", "Lain-lain"] ]
	end

end
