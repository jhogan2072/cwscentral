module ApplicationHelper
  def generate_xls(report_records, output_columns)
    #output_columns = [:title, :due_date]

    String.new.tap do |str|
      str << "<html><head></head><body><table border='1'>"
      str << "<tr>"
      output_columns.each do |col|
        str << "<th>#{humanize(col)}</th>"
      end
      str << '</tr>'

      report_records.each do |record|
        str << "<tr>"
        output_columns.each do |col|
          str << "<td>#{record.send(col)}</td>"
        end
        str << "</tr>"
      end
      str << "</table></body></html>"
    end
  end

end
