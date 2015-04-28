class IncomeReportPdf < DefaultReportPdf
  def initialize(statement, view)
    super()
    @statement = statement
    @view = view
    header
    move_down(20)
    table_content
    # text_content
  end
 
  def title
    "Laporan Laba-Rugi #{@statement.firm.name} Tahun #{@statement.year}"
  end
 
  def table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths
    # y_position = cursor - 50
    table account_rows do
      row(0).font_style = :bold_italic
      row(0).align = :center
      row(5).font_style = :bold_italic
      row(5).align = :center
      row(9).font_style = :bold_italic
      row(9).align = :center
      # self.header = true
      self.row_colors = ['F0FFF0', 'FFFFFF']
      self.column_widths = [300, 200]
    end
  end
 
  def account_rows
    [
      ['Pendapatan', to_idr(@statement.revenue)], 
      ['Biaya Pokok', to_idr(@statement.cost_of_revenue)],
      ['Laba(Rugi) Kotor', to_idr(@statement.gross_profit)],
      ['Beban Operasi', to_idr(@statement.operating_expense)],
      ['Pendapatan & Beban Non-Operasi', to_idr(@statement.comprehensive_items)],
      ['Laba(Rugi) Operasi', to_idr(@statement.earning_before_int_and_tax)],
      ['Beban Bunga', to_idr(@statement.interest_expense) ],
      ['Laba(Rugi) Sebelum Pajak', to_idr(@statement.earning_before_tax)],
      ['Beban Pajak', to_idr(@statement.tax_expense) ],
      ['Laba(Rugi) Bersih', to_idr(@statement.net_income) ],
    ]
  end

end