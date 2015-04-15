module ApplicationHelper

  def title(value)
    unless value.nil?
      @title = "#{value} | KAPITEN"
    end
  end

  def has_payable?(item)
    value = item.spending.payment_installed
    if value == 0
      content_tag(:small, 'secara Lunas', class: 'turq')
    else
      content_tag(:small, 'dengan hutang ' + idr_money(value), class: 'coral payable') 
    end
  end

  def total_payables(array, option)
    array.inject(0) do |sum, item|
      if item.spending.payment_installed > 0
        if option == 'sum'
          sum = (item.payment_installed)
          rescue_value(sum)
        elsif option == 'count'
          count =+ 1
          rescue_count(count)
        end
      end
    end
  end

  def accumulator(array, field, option)
    value = array.map{ |a| a[field]}.compact.sum
    if option == 'money'
      return idr_money(value)
    elsif option == 'round'
      return number_with_precision(value, precision: 0, separator: ',', 
        delimiter: '.')
    elsif option == 'decimal'
      return number_with_precision(value, precision: 1, separator: ',', 
        delimiter: '.')
    end
  end
  
  def unit_remaining(array, field_1, field_2, option)
    value_1 = array.map{ |a| a[field_1]}.compact.sum
    value_2 = array.map{ |a| a[field_2]}.compact.sum
    if option == 'money'
      return idr_money((value_1 - value_2).abs)
    elsif option == 'round'
      return number_with_precision((value_1 - value_2).abs, precision: 0, separator: ',', 
        delimiter: '.')
    elsif option == 'decimal'
      return number_with_precision((value_1 - value_2).abs, precision: 1, separator: ',', 
        delimiter: '.')
    end
  end

  def averager(array, field)
    idr_money(array.map{ |a| a[field] }.compact.sum / array.size)
  end


  def trans_info_tip
  	"Informasi tambahan yang menurutmu penting untuk dicatat, 
  	misalnya: nama pihak yang terlibat dalam transaksi"
  end

  def trans_date_tip
	"Tanggal transaksi dilakukan"
  end

  def trans_installment_tip
  	"Klik kotak 'Dicicil?' apabila pembayaran melibatkan cicilan"
  end

  def trans_dp_tip
  	"Pembayaran tunai yang dibayar di muka"
  end

  def trans_discount_tip
  	"Persentase diskon yang akan diberikan apabila memenuhi syarat"
  end

  def trans_maturity_tip
  	"Tanggal jatuh tempo cicilan"
  end  

  def trans_total_tip
  	"Total yang harus dibayarkan (tunai + cicilan)"
  end

  def link_fa_to(icon_name, text, link)
    link_to content_tag(:i, text, :class => "fa fa-#{icon_name}"), link
  end

  def idr_money(number)
    number_to_currency(number, unit: "Rp ", separator: ",", 
                       delimiter: ".", negative_format: "(%u%n)",
                       raise: true, precision: 0)
# => R$1234567890,50
  end

  def rescue_count(count)
    if count == 0
      return "0"
    else
      return count
    end
  end

  def rescue_value(value)
    if value == 0
      return 0
    else
      return value
    end
  end

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

end
