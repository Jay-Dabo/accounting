class BalanceReportPdf < DefaultReportPdf
  def initialize(balance, view)
    super()
    @balance = balance
    @view = view
    header
    move_down(20)
    aktiva_table_content
    passiva_table_content
    # text_content
  end
 
  def title
    "Laporan Neraca #{@balance.firm.name} Tahun #{@balance.year}"
  end
 
  def aktiva_table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths
    table aktiva_account_rows do
      row(0).font_style = :bold
      row(8).font_style = :bold_italic
      row(8).align = :center
      self.header = true
      self.row_colors = ['F0FFF0', 'FFFFFF']
      self.column_widths = [300, 200]
    end
  end
 
  def aktiva_account_rows
    [['Aset Usaha', ''], 
      ['Kas dan Setaranya', to_idr(@balance.cash)],
      ['Piutang Usaha', to_idr(@balance.receivables)],
      ['Stok Barang', to_idr(@balance.inventories)],
      ['Perlengkapan', to_idr(@balance.supplies)],
      ['Aset Prabayar', to_idr(@balance.prepaids)],
      ['Aset Tetap', to_idr(@balance.fixed_assets)],
      ['Akumulasi Penyusutan', to_idr(@balance.accu_depr)],
      ['Total Aset', to_idr(@balance.aktiva)]
    ]
  end

  def passiva_table_content
    table passiva_account_rows do
      row(0).font_style = :bold
      row(6).font_style = :bold_italic
      row(6).align = :center      
      self.header = true
      self.row_colors = ['F0FFF0', 'FFFFFF']
      self.column_widths = [300, 200]
    end
  end
 
  def passiva_account_rows
    [['Kewajiban dan Hak Pemilik', ''], 
      ['Hutang Usaha', to_idr(@balance.payables)],
      ['Pinjaman', to_idr(@balance.debts)],
      ['Laba Ditahan', to_idr(@balance.retained)],
      ['Penarikan Dana', to_idr(@balance.drawing)],
      ['Dana Pemilik', to_idr(@balance.capital)],
      ['Total Kewajiban & Hak Pemilik', to_idr(@balance.passiva)]
    ]
  end

end