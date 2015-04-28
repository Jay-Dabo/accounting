class CashReportPdf < DefaultReportPdf
  def initialize(flow, view)
    super()
    @flow = flow
    @view = view
    header
    move_down(20)
    table_content
    # text_content
  end
 
  def title
    "Laporan Arus Kas #{@flow.firm.name} Tahun #{@flow.year}"
  end

  def table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths
    y_position = cursor - 50
    
    # text "Operasi Usaha", size: 16

    table operating_account_rows do
      row(0).font_style = :bold
      row(7).font_style = :bold_italic
      row(7).align = :center
      self.header = true
      self.row_colors = ['F0FFF0', 'FFFFFF']
      self.column_widths = [300, 200]
    end

    # text "Aktivitas Investasi Usaha", size: 16

    table investing_account_rows do
      row(0).font_style = :bold
      row(3).font_style = :bold_italic
      row(3).align = :center
      self.header = true
      self.row_colors = ['F0FFF0', 'FFFFFF']
      self.column_widths = [300, 200]
    end

    # text "Aktivitas Pendanaan Usaha", size: 16
    table financing_account_rows do
      row(0).font_style = :bold
      row(5).font_style = :bold_italic
      row(5).align = :center
      self.header = true
      self.row_colors = ['F0FFF0', 'FFFFFF']
      self.column_widths = [300, 200]
    end

    table ending_account_rows do
      row(0).font_style = :bold_italic
      row(2).font_style = :bold_italic
      row(0).align = :center
      row(1).align = :center
      row(2).align = :center
      self.header = true
      self.row_colors = ['F0FFF0', 'FFFFFF']
      self.column_widths = [300, 200]
    end    
  end
 
  def operating_account_rows
    [
      ['Operasi Usaha', ''], 
      ['Laba(Rugi) Usaha', to_idr(@flow.total_income)],
      ['Penyusutan Aset Tetap', to_idr(@flow.depreciation_adjustment)],
      ['Laba(Rugi) Penjualan Aset Tetap', to_idr(@flow.total_gain_loss_from_asset)],
      ['Perubahan Saldo Piutang Usaha', to_idr(@flow.receivable_flow)],
      ['Perubahan Saldo Stok Barang', to_idr(@flow.inventory_flow)],
      ['Perubahan Saldo Hutang Usaha', to_idr(@flow.payable_flow)],
      ['Arus Kas Dari Operasi Usaha', to_idr(@flow.net_cash_operating)]
    ]
  end

  def investing_account_rows
    [
      ['Aktivitas Investasi', ''], 
      ['Penjualan Aset Tetap', to_idr(@flow.asset_sale)],
      ['Pembelian Aset Tetap', to_idr(@flow.asset_purchase)],
      ['Arus Kas Dari Investasi Usaha', to_idr(@flow.net_cash_financing)]
    ]
  end

  def financing_account_rows
    [
      ['Aktivitas Pendanaan', ''], 
      ['Penambahan Dana Pemilik', to_idr(@flow.capital_injection)],
      ['Penarikan Dana Pemilik', to_idr(@flow.capital_withdrawal)],
      ['Penambahan Dana Pinjaman', to_idr(@flow.loan_injection)],
      ['Pelunasan Dana Pinjaman', to_idr(@flow.loan_payment)],
      ['Arus Kas Dari Pendanaan Usaha', to_idr(@flow.net_cash_financing)]
    ]
  end

  def ending_account_rows
    [
      ['Total Perubahan Saldo Kas', to_idr(@flow.net_change)], 
      ['Saldo Awal Kas', to_idr(@flow.beginning_cash)],
      ['Saldo Akhir Kas', to_idr(@flow.ending_cash)]
    ]
  end

end