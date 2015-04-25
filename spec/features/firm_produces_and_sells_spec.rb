require 'rails_helper'

feature "FirmProducesAndSells", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:producer) { FactoryGirl.create(:producer) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: producer) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: producer) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: producer, fiscal_year: fiscal_2015) }  
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: producer, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: producer, fiscal_year: fiscal_2015) }
  let!(:capital_1) { FactoryGirl.create(:capital_injection, firm: producer) }

  before { sign_in user }

  describe "creating type of product" do
 	let!(:material_spending) { FactoryGirl.create(:material_spending, firm: producer) }
	let!(:material_1) { FactoryGirl.create(:material, firm: producer, spending: material_spending) }

  	before do
  		click_link "+ Jenis Produk"
  		fill_in("product[product_name]", with: "Kemeja Biru") 
  		fill_in("product[hour_needed]", with: 0.5) 
  		fill_in("product[measurement]", with: "Buah") 
  		click_button "Simpan" 
  	end

  	it { should have_content('Jenis Produk Telah Dicatat') }

  	describe "checking the list" do
  		before { click_list("Stok Produk") }
  		it { should have_css(".name", text: "Kemeja Biru") }
  		# it { should have_content("galih") }
  	end

  	describe "account the production" do
  		before do
  			visit user_root_path
  			click_link "+ Hasil Produksi"
  			# fill_in("assembly[date_of_assembly]", with: "01/02/2015")
			fill_in("assembly[date]", with: 10)
			fill_in("assembly[month]", with: 1)  			
  			select "Kemeja Biru", from: 'Produk Yang Diproduksi'
  			fill_in("assembly[produced]", with: 5)
			first_nested_fields = all('.nested-fields').first	
			within(first_nested_fields) do
				select material_1.material_name, from: 'Kelompok Bahan Baku'
				fill_in "Jumlah Terpakai", with: 5
  			end
			click_button "Simpan" 
  		end

  		it { should have_content('Hasil produksi berhasil dicatat') }

  		describe "checking the assembly records" do
  			before { click_list("Produksi") }
  			it { should have_css(".produced", text: 5) }
	  		it { should have_css(".info-spent", text: "Rp 500.000") }
  		end

	  	describe "checking the balance sheet" do
	  		before { click_neraca(2015) }

	  		it { should have_css("th#inventories", text: material_1.cost) }
	  		it { should have_content("Balanced") }
	  	end
		
		describe "editing the assembly records" do

			describe "editing the quantity produced" do
				before do
					click_link "Koreksi"
					fill_in("assembly[date]", with: 10)
					fill_in("assembly[month]", with: 1)
					fill_in("assembly[produced]", with: 3)
					click_button "Simpan"
				end

				it { should have_content('Hasil produksi berhasil dikoreksi') }
		  		it { should have_css(".produced", text: 3) }
			  	it { should have_css(".info-spent", text: "Rp 500.000") }	

			  	describe "checking the balance sheet" do
			  		before { click_neraca(2015) }

			  		it { should have_css("th#inventories", text: material_1.cost_per_unit * 5) }
			  		it { should have_content("Balanced") }
			  	end			  				  	
			end

			describe "editing the cost in production" do
				before do
					click_link "Koreksi"
					fill_in("assembly[date]", with: 10)
					fill_in("assembly[month]", with: 1)					
					fill_in("assembly[produced]", with: 5)
					first_nested_fields = all('.nested-fields').first	
					within(first_nested_fields) do
						select material_1.material_name, from: 'Kelompok Bahan Baku'
						fill_in "Jumlah Terpakai", with: 3
		  			end					
					click_button "Simpan"
				end

				it { should have_content('Hasil produksi berhasil dikoreksi') }
			  	it { should have_css(".info-spent", text: "Rp 800.000") }	

			  	describe "checking the balance sheet" do
			  		before { click_neraca(2015) }

			  		it { should have_css("th#inventories", text: material_1.cost_per_unit * 25) }
			  		it { should have_content("Balanced") }
			  	end			  	
			end			
		end

  		describe "checking the material records" do
  		end

	  	describe "checking the product list" do
	  		before { click_list("Stok Produk") }
	  		it { should have_css(".name", text: "Kemeja Biru") }
	  		it { should have_css(".produced", text: 5) }
	  		it { should have_content("Rp 500.000") } #material_1.cost_per_unit * 5
	  	end

	  	describe "checking the cash flow" do
	  		before { click_flow(2015) }
	  		it { should have_css("#inventory", text: material_1.cost_per_unit * 25) } 
	  		# it { should have_content("galih") } #ending cash should be 8000500
	  	end

	  	describe "selling the product" do
	  		let!(:cash_earned) { 750000 }
		    before do
	        visit user_root_path
	        click_href("Penjualan Produk", new_firm_revenue_path(producer, type: 'Product'))
	        # fill_in("revenue[date_of_revenue]", with: "10/02/2015") 
	        fill_in("revenue[date]", with: 10) 
	        fill_in("revenue[month]", with: 2) 
	        select "Kemeja Biru", from: 'revenue_item_id'
	        fill_in("revenue[quantity]", with: 5)
	        fill_in("revenue[total_earned]", with: cash_earned)
	        fill_in("revenue[info]", with: 'Blablabla')
	        click_button "Simpan"        
	      end

		it { should have_content('Pendapatan berhasil dicatat') }  

	  	describe "checking the product list" do
	  		before { click_list("Stok Produk") }
	  		it { should have_css(".name", text: "Kemeja Biru") }
	  		it { should have_css(".sold", text: 5) }
	  	end

	  	describe "checking the income statement" do
	  		before { click_statement(2015) }

        	it { should have_css('th#revenue', text: cash_earned) } # for the revenue account
	      		it { should have_css('th#cost_revenue', text: material_1.cost_per_unit * 5) } # for the cost of revenue
	    	it { should have_css('th#retained', text: cash_earned - material_1.cost_per_unit * 5) } # for the retained earning balance
	  	end

	  	describe "checking the balance sheet" do
	  		before { click_neraca(2015) }
	  		it { should have_css("th#inventories", text: material_1.cost_per_unit * 20) }
	  		it { should have_content("Balanced") }
	  		# it { should have_content("galih") }
	  	end

	  	describe "checking the cash flow" do
	  		before { click_flow(2015) }
	  		it { should have_css("#inventory", text: material_1.cost_per_unit * 20) } 
	  		# it { should have_content("galih") } #ending cash should be 8000500
	  	end				
      end
  	end

	end
end
