class DateTimePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    template.content_tag(:div, class: 'input-group date form_datetime') do
      template.concat @builder.text_field(attribute_name, input_html_options)
      template.concat span_table
    end
  end

  def input_html_options
    super.merge({class: 'form-control input-sm', style: 'font-size: 14px', value: convert_date(@builder.object.send(attribute_name))})
  end

  def span_table
    template.content_tag(:span, class: 'input-group-addon') do
      template.concat icon_table
    end
  end

  def icon_table
    "<span class='glyphicon-calendar glyphicon'></span>".html_safe
  end

  def convert_date(value)
    case value
      when Date, Time, DateTime
        format = options[:format] || :medium
        value.strftime('%d-%b-%Y')
      else
        value.to_s
    end
  end
end