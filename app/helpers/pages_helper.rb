module PagesHelper

  # Spending link_to tooltip
  def spend_merch_tip
    "pembelian stok dagang penting untuk dicatat"
  end

  def spend_material_tip
    "pembelian stok bahan baku untuk produksi"
  end

  def spend_expendable_tip
    "pembelian aset lancar seperti peralatan dan perlengkapan yang akan 
    dipakai dan dapat habis untuk usaha BUKAN untuk diperdagangkan atau
     sebagai bahan baku produksi. Contohnya adalah hak sewa, alat tulis, dll."
  end

  def spend_fixed_tip
    "yang dimaksud dengan aset tetap adalah sumber daya jangka panjang 
    yang akan digunakan untuk usaha BUKAN untuk diperdagangkan atau 
    sebagai bahan baku produksi. Contoh: mesin, kendaraan, bangunan."    
  end

  def spend_expense_tip
    "yang termasuk dalam pengeluaran adalah pembayaran atas biaya yang 
    muncul dalam operasi usaha, seperti listrik, gaji, pemasaran, dll."    
  end

  def spend_payable_tip
    "pembayaran atas hutang usaha, seperti hutang dalam pembelian stok dagang"
  end

  # Revenue link_to tooltip
  def rev_merch_tip
    "penghasilan berasal dari penjualan stok dagang"
  end

  def rev_service_tip
    "penghasilan dari jasa usaha yang diberikan kepada pelanggan"
  end

  def rev_product_tip
    "penghasilan berasal dari penjualan stok produk hasil produksi"
  end

  def rev_asset_tip
    "Sumber pendapatan adalah penjualan aset lancar diperoleh 
    (perlengkapan, persediaan, aset prabayar), peralatan, bangunan, 
    kendaraan, mesin dan aset tetap tidak berwujud seperti paten dan royalti"
  end

  def rev_receivable_tip
    "penerimaan pembayaran piutang usaha dari pelanggan"
  end

  def rev_other_tip
    "penghasilan yang didapat tanpa menjual aset ataupun stok, 
    seperti pendapatan bunga dan pendapatan sewa"
  end

#Operation Panel tip
  def service_panel_tip
    "Catat jenis jasa untuk memulai pembukuan pendapatan jasa dengan 
    mengklik tombol '+ Jenis Jasa'. Dan untuk mencatat pemakaian 
    atau habisnya persediaan perlengkapan dan aset prabayar, 
    klik 'Penggunaan Persediaan'"
  end    

  def production_panel_tip
    "Catat jenis produk untuk memulai pembukuan pendapatan produk dengan 
    mengklik tombol '+ Jenis Produk'. Untuk mencatat hasil produksi, 
    pastikan bahan baku produksi yang akan digunakan sudah tercatat.
    Dan untuk mencatat pemakaian atau habisnya persediaan perlengkapan 
    dan aset prabayar, klik 'Penggunaan Persediaan'"
  end

  def trading_panel_tip
    "Untuk memulai pembukuan pendapatan jual beli, pastikan stok produk sudah
    tercatat, kalau belum atau habis, tambahkan di Panel Pengeluaran.
    Dan untuk mencatat pemakaian atau habisnya persediaan perlengkapan 
    dan aset prabayar, klik 'Penggunaan Persediaan'"
  end  

  def payable_receivable_panel_tip
  	"catat pelunasan hutang dan piutang yang melibatkan pelanggan
  	atau pemasok (supplier, vendor) kamu. Untuk 
  	membayar hutang dari bank atau lembaga pembiayaan lain, lihat Panel Dana"
  end

  def expending_tip(type)
    "Catat #{type} yang telah habis terpakai atau kadaluwarsa dalam operasi usaha"
  end

  def add_produced
    'Catat hasil produksi untuk menambahkan kuantitas stok produk'
  end

# Cash Panel tip
	def capital_panel_tip
		"Klik 'Tambah Modal' apabila ada penambahan modal
		dari pemilik atau investor. Apabila ada penarikan dana atau pembagian
		hasil usaha dengan pemilik atau investor, klik 'Tarik Uang'."
	end

	def loan_panel_tip
		"Klik 'Tambah Pinjaman' apabila ada penambahan pinjaman
		dari orang ataupun lembaga keuangan. 
		Untuk mencatat pelunasan pinjaman, klik 'Bayar Pinjaman'."
	end

# Earning Panel
	def sales_panel_tip(firm)
		if firm.type == 'Manufaktur'
			"Klik 'Penjualan Produk' untuk mencatat penjualan hasil produksi.
			Pastikan hasil produksi telah ada dan tercatat."
		elsif firm.type == 'Jasa'
			"Klik 'Penjualan Jasa' untuk mencatat pendapatan dari jasa yang 
			usahamu sediakan.
			Pastikan jenis jasa telah tercatat, bila belum lihat panel operasi
			dan klik '+ Jenis Jasa"
		elsif firm.type == 'Jual-Beli'
			"Klik 'Penjualan Produk' untuk mencatat penjualan stok produk.
			Pastikan stok produk masih ada dan telah tercatat, 
			bila belum lihat Panel Pengeluaran dan klik 'Tambah Stok Produk"
		end
	end

	def compre_income_panel_tip
		"Klik 'Penjualan Aset Lancar' apabila ada penjualan persediaan 
		perlengkapan usaha atau aset prabayar, 
		dan 'Penjualan Aset Tetap' 
		apabila ada penjualan persediaan peralatan, mesin, atau bangunan
		milik usaha. 
		Klik 'Pendapatan Non-Penjualan' untuk pendapatan yang 
		tidak berasal dari penjualan, seperti dari bunga bank atau deposito"
	end

# Expenditure Panel
	def current_asset_panel_tip(firm)
		if firm.type == 'Manufaktur'
			"Klik 'Pembelian Bahan Baku' untuk mencatat pembelian 
			bahan yang akan dipakai untuk produksi barang jadi."
		elsif firm.type == 'Jual-Beli'
			"Klik 'Tambah Stok Produk' untuk mencatat pembelian 
			stok produk untuk dijual."
		end
		"Klik 'Pembelian Perlengkapan Usaha' untuk pembelian barang-barang 
		yang sifatnya akan habis karena pemakaian, dan 
		'Pembelian Aset Prabayar' untuk beban yang dibayar di muka dan 
		akan habis, seperti beban sewa bangunan"
	end

	def fixed_asset_panel_tip
		"Klik 'Pembelian Aset Tetap' untuk menambahkan aset tetap ke 
		dalam usaha. Yang termasuk aset tetap adalah: mesin, kendaraan, bangunan,
		dan aset tetap tak berwujud seperti logo, paten, dan kontrak"
	end

	def expense_panel_tip
		"Klik 'Pembayaran Beban' untuk mencatat pengeluaran yang muncul dalam
		kegiatan operasi usaha dalam mencetak pemasukkan, contohnya:
		biaya pemasaran, gaji karyawan, listrik & air, transportasi, dll."
	end	




end