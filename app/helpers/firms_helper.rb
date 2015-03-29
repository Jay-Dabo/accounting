module FirmsHelper

	def business_type_options
		[ ["Jual-Beli", "Jual-Beli"], ["Jasa", "Jasa"],
     	["Manufaktur/Produksi", "Manufaktur"] ]		
	end

	def industry_options
		[ ["Makanan & Minuman", "Makanan & Minuman"], 
		      ["Pakaian", "Pakaian"], ["Teknologi", "Teknologi"], 
		      ["Elektronik", "Elektronik"], ["Material", "Material"], 
		      ["Konstruksi", "Konstruksi"], ["Kreatif", "Kreatif"], 
		      ["Lain-lain", "Lain-lain"] ]
	end

end
