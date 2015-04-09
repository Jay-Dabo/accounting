module ApplicationHelper

  def title(value)
    unless value.nil?
      @title = "#{value} | KAPITEN"
    end
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
    number_to_currency(number, unit: "Rp", separator: ",", 
                       delimiter: ".", negative_format: "(%u%n)",
                       raise: true, precision: 0)
# => R$1234567890,50
  end

end
