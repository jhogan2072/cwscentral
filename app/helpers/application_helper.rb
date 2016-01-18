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

  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, 'remove_fields(this)')
  end

  def add_child_link(name, f, method, css_class)
    fields = new_child_fields(f, method)
    link_to_function(name, h("insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\",'" +  css_class + "')"))
  end

  def child_link_javascript(f, method, css_class)
    fields = new_child_fields(f, method)
    h("insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\",'" + css_class + "')")
  end

  def new_child_fields(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f
    form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end
  end
end
