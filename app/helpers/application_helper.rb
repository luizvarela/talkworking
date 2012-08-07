module ApplicationHelper
  
  def format_string_with_new_line(str, size =15)
    return "" if str.nil?
    
    if str.size <= size
      "#{str} \n"
    else
      "#{str[0..size]} \n #{str[size..size + 15]}"
    end
  end
  
  def format_string_with_reluctance(str, size = 30)
    return "" if str.nil?
    
    if str.size <= size
      str
    else
      str[0..size] + "..."
    end
  end
  
  def datepicker_tag(model, attribute, options ={}, datepicker_options = {})
    field_id = "#{model}_#{attribute}"   
    field_name = "#{model}[#{attribute}]"
    field = ::ActionView::Helpers::InstanceTag.new(model, attribute, self)       
    options = {:id => field_id, :name => field_name}.merge(options)
    datepicker_options = options_for_javascript(datepicker_options)
    js = "$(document).ready(function() { $(\"\##{field_id}\").datepicker(#{datepicker_options});});"
    field.tag(:input, options) + javascript_tag(js)   
  end
  
  def colorpicker_tag(model, attribute, options ={})
    field_id = "#{model}_#{attribute}"   
    field_name = "#{model}[#{attribute}]"
    field = ::ActionView::Helpers::InstanceTag.new(model, attribute, self)       
    options = {:id => field_id, :name => field_name}.merge(options)
    colorpicker_option = '{onChange: function (hsb, hex, rgb) {$("#' + field_id + '").val("#" + hex);},onSubmit: function(hsb, hex, rgb, el) {$(el).val("#" + hex);$(el).ColorPickerHide();},onBeforeShow: function () {$(this).ColorPickerSetColor(this.value);}}).bind("keyup", function(){$(this).ColorPickerSetColor(this.value);}'
    js = "$(document).ready(function() { $(\"\##{field_id}\").ColorPicker(#{colorpicker_option});});"   
    field.tag(:input, options) + javascript_tag(js)   
  end
  
  def comments(comentavel)
    comentarios = "<div id='comentarios'>"
    comentarios << render(:partial => "comments/comment", :collection => comentavel.comments) unless comentavel.comments.empty?
    comentarios << "</div>"
    raw comentarios
  end
  
  def historicals(historical)
    historicals = "<div id='historicals'>"
    historicals << render(:partial => "historicals/historical", :collection => historical.historical) unless historical.historical.empty?
    historicals << "</div>"
    raw historicals
  end
  
  def new_comment(comentavel)
           raw render(:partial => "comments/form",
                             :locals => { :comentavel => comentavel })
  end
end
