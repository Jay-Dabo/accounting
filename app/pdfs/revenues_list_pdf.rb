class RevenuesListPdf < DefaultReportPdf
  def initialize(revenues, view)
    super()
    @revenues = revenues
    @view = view
    header
    move_down(20)
    table_content
    # text_content
  end
 
  def title
    "Riwayat Pendapatan #{@revenues.first.firm.name} Tahun #{@revenues.first.year}"
  end

  def table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths
    y_position = cursor - 50
    
    # text "Operasi Usaha", size: 16

    table list_rows do
      row(0).font_style = :bold
      # row(7).font_style = :bold_italic
      # row(7).align = :center
      self.header = true
      self.row_colors = ['F0FFF0', 'FFFFFF']
      self.column_widths = [100, 100, 200, 200]
    end

  end
 
  def list_rows
    [['Tanggal', 'Jenis', 'Nilai', 'Status']] +
      @revenues.map do |rev|
      [rev.date_of_revenue, rev.item_type, rev.total_earned, 
        status_of_earning(rev)]
    end
  end

end