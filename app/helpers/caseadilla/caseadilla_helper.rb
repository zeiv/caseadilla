module Caseadilla
  module CaseadillaHelper
  
    def caseadilla_get_footer_string include_version = false
      if include_version
        "Running on #{link_to 'Caseadilla', 'http://www.github.com/zeiv/caseadilla'} #{caseadilla_get_full_version_string}, an open-source project.".html_safe
      else
        "Running on #{link_to 'Caseadilla', 'http://www.github.com/zeiv/caseadilla'}, an open-source project.".html_safe
      end
    end
  
    def caseadilla_get_full_version_string
      Caseadilla::VERSION
    end
  
    def caseadilla_get_short_version_string
      Caseadilla::VERSION.slice(0..(str.index('.')))
    end
  
    def caseadilla_generate_page_title
    
      if @caseadilla_page_title.nil?
        return caseadilla_config_website_name
      end
    
      caseadilla_config_website_name + " > " + @caseadilla_page_title  
    end
  
    def caseadilla_get_access_level_text level
      case level
        when $CASEIN_USER_ACCESS_LEVEL_ADMIN
          return "Administrator"
        when $CASEIN_USER_ACCESS_LEVEL_USER
          return "User"
        else
          return "Unknown"
      end
    end
  
    def caseadilla_get_access_level_array
      [["Administrator", $CASEIN_USER_ACCESS_LEVEL_ADMIN], ["User", $CASEIN_USER_ACCESS_LEVEL_USER]]
    end

    def caseadilla_pagination_details objs
      " <small class='pagination-details'>/ page #{objs.current_page} of #{objs.total_pages}</small>".html_safe if objs.current_page && objs.total_pages > 1
    end
  
    def caseadilla_table_cell_link contents, link, options = {}
    
      if options.key? :caseadilla_truncate
        contents = truncate(contents, :length => options[:caseadilla_truncate], :omission => "...")
      end
    
      link_to "#{contents}".html_safe, link, options
    end
    
    def caseadilla_table_cell_no_link contents, options = {}
    
      if options.key? :caseadilla_truncate
        contents = truncate(contents, :length => options[:caseadilla_truncate], :omission => "...")
      end
    
      "<div class='no-link'>#{contents}</div>".html_safe
    end
  
    def caseadilla_show_icon icon_name
      "<div class='icon'><span class='glyphicon glyphicon-#{icon_name}'></span></div>".html_safe
    end
  
    def caseadilla_show_row_icon icon_name
      "<div class='iconRow'><span class='glyphicon glyphicon-#{icon_name}'></span></div>".html_safe
    end

    def caseadilla_format_date date, format = "%b %d, %Y"
      date.strftime(format)
    end

    def caseadilla_format_time time, format = "%H:%M"
      time.strftime(format)
    end

    def caseadilla_format_datetime datetime, format = "%b %d, %Y %H:%M"
      datetime.strftime(format)
    end

    def caseadilla_sort_link title, column, options = {}
      condition = options[:unless] if options.has_key?(:unless)
      icon_to_show_html = "<div class='table-header-icon'>&nbsp;</div>".html_safe
      if params[:c].to_s == column.to_s
        icon_to_show = params[:d] == 'down' ? 'chevron-up' : 'chevron-down'
        icon_to_show_html = "<div class='table-header-icon glyphicon glyphicon-#{icon_to_show}'></div>".html_safe
      end
      sort_dir = params[:d] == 'down' ? 'up' : 'down'
      link_to_unless(condition, title, request.parameters.merge({:c => column, :d => sort_dir})) + icon_to_show_html
    end

    def caseadilla_yes_no_label value
      if value
        return "<span class='label label-success'>Yes</span>".html_safe
      else
        return "<span class='label label-danger'>No</span>".html_safe
      end
    end

    def caseadilla_no_yes_label value
      if value
        return "<span class='label label-danger'>Yes</span>".html_safe
      else
        return "<span class='label label-success'>No</span>".html_safe
      end
    end
  
    # Styled form tag helpers
  
    def caseadilla_text_field form, obj, attribute, options = {}
      caseadilla_form_tag_wrapper(form.text_field(attribute, strip_caseadilla_options(options_hash_with_merged_classes(options, 'form-control'))), form, obj, attribute, options).html_safe
    end
  
    def caseadilla_password_field form, obj, attribute, options = {}
      caseadilla_form_tag_wrapper(form.password_field(attribute, strip_caseadilla_options(options_hash_with_merged_classes(options, 'form-control'))), form, obj, attribute, options).html_safe
    end
  
    def caseadilla_text_area form, obj, attribute, options = {}
      caseadilla_form_tag_wrapper(form.text_area(attribute, strip_caseadilla_options(options_hash_with_merged_classes(options, 'form-control'))), form, obj, attribute, options).html_safe
    end
  
    def caseadilla_text_area_wysiwyg form, obj, attribute, options = {}
      options.reverse_merge!({style: "height: 250px;"})
      caseadilla_form_tag_wrapper(form.text_area(attribute, strip_caseadilla_options(options_hash_with_merged_classes(options, 'form-control wysihtml5'))), form, obj, attribute, options).html_safe
    end
  
    def caseadilla_check_box form, obj, attribute, options = {}
      form_tag = "<div class='check-box'>#{form.check_box(attribute, strip_caseadilla_options(options))}</div>".html_safe
      caseadilla_form_tag_wrapper(form_tag, form, obj, attribute, options).html_safe
    end
  
    def caseadilla_check_box_group form, obj, check_boxes = {}
      form_tags = ""
    
      for check_box in check_boxes
        form_tags += caseadilla_check_box form, obj, check_box[0], check_box[1]
      end
    
      caseadilla_form_tag_wrapper(form_tag, form, obj, attribute, options)
    end
  
    def caseadilla_radio_button form, obj, attribute, tag_value, options = {}
      form_tag = form.radio_button(obj, attribute, tag_value, strip_caseadilla_options(options))
    
      if options.key? :caseadilla_button_label
        form_tag = "<div>" + form_tag + "<span class=\"rcText\">#{options[:caseadilla_button_label]}</span></div>".html_safe
      end
    
      caseadilla_form_tag_wrapper(form_tag, form, obj, attribute, options).html_safe
    end
  
    def caseadilla_radio_button_group form, obj, radio_buttons = {}
      form_tags = ""
    
      for radio_button in radio_buttons
        form_tags += caseadilla_radio_button form, obj, check_box[0], check_box[1], check_box[2]
      end
    
      caseadilla_form_tag_wrapper(form_tag, form, obj, attribute, options).html_safe
    end
  
    def caseadilla_select form, obj, attribute, option_tags, options = {}
      caseadilla_form_tag_wrapper(form.select(attribute, option_tags, strip_caseadilla_options(options), merged_class_hash(options, 'form-control')), form, obj, attribute, options).html_safe
    end
    
    def caseadilla_time_zone_select form, obj, attribute, option_tags, options = {}
      caseadilla_form_tag_wrapper(form.time_zone_select(attribute, option_tags, strip_caseadilla_options(options), merged_class_hash(options, 'form-control')), form, obj, attribute, options).html_safe
    end
  
    def caseadilla_collection_select form, obj, attribute, collection, value_method, text_method, options = {}
      caseadilla_form_tag_wrapper(collection_select(obj.class.name.downcase.to_sym, attribute, collection, value_method, text_method, strip_caseadilla_options(options), merged_class_hash(options, 'form-control')), form, obj, attribute, options).html_safe
    end
  
    def caseadilla_collection_check_boxes form, obj, attribute, collection, value_method, text_method, options = {}
      caseadilla_form_tag_wrapper(collection_check_boxes(obj, attribute, collection, value_method, text_method, strip_caseadilla_options(options), merged_class_hash(options, 'form-control')), form, obj, attribute, options).html_safe
    end
    
    def caseadilla_date_select form, obj, attribute, options = {}
      caseadilla_form_tag_wrapper("<div class='caseadilla-date-select'>".html_safe + form.date_select(attribute, strip_caseadilla_options(options), merged_class_hash(options, 'form-control')) + "</div>".html_safe, form, obj, attribute, options).html_safe
    end

    def caseadilla_time_select form, obj, attribute, options = {}
      caseadilla_form_tag_wrapper("<div class='caseadilla-time-select'>".html_safe + form.time_select(attribute, strip_caseadilla_options(options), merged_class_hash(options, 'form-control')) + "</div>".html_safe, form, obj, attribute, options).html_safe
    end
  
    def caseadilla_datetime_select form, obj, attribute, options = {}
      caseadilla_form_tag_wrapper("<div class='caseadilla-datetime-select'>".html_safe + form.datetime_select(attribute, strip_caseadilla_options(options), merged_class_hash(options, 'form-control')) + "</div>".html_safe, form, obj, attribute, options).html_safe
    end
  
    def caseadilla_file_field form, obj, object_name, attribute, options = {}
      class_hash = merged_class_hash(options, 'form-control')
      contents = "<div class='#{class_hash[:class]}'>" + file_field(object_name, attribute, strip_caseadilla_options(options)) + '</div>'

      if options.key? :caseadilla_contents_preview
        contents = options[:caseadilla_contents_preview].html_safe + contents.html_safe
      end

      caseadilla_form_tag_wrapper(contents, form, obj, attribute, options).html_safe
    end
  
    def caseadilla_hidden_field form, obj, attribute, options = {}
      form.hidden_field(attribute, strip_caseadilla_options(options)).html_safe
    end

    def caseadilla_custom_field form, obj, attribute, custom_contents, options = {}
      caseadilla_form_tag_wrapper(custom_contents, form, obj, attribute, options).html_safe
    end
  
  protected

    def strip_caseadilla_options options
      options.reject {|key, value| key.to_s.include? "caseadilla_" }
    end
    
    def merged_class_hash options, new_class
      if options.key? :class
        new_class += " #{options[:class]}"
      end
        
      {:class => new_class}
    end
    
    def options_hash_with_merged_classes options, new_class
      if options.key? :class
        new_class += " #{options[:class]}"
      end
      options[:class] = new_class
      options
    end

    def caseadilla_form_tag_wrapper form_tag, form, obj, attribute, options = {}
        unless options.key? :caseadilla_label
          human_attribute_name = attribute.to_s.humanize
        else
          human_attribute_name = options[:caseadilla_label]
        end

        sublabel = ""

        if options.key? :caseadilla_sublabel
          sublabel = " <small>#{options[:caseadilla_sublabel]}</small>".html_safe
        end

        html = ""

        if obj && obj.errors[attribute].any?
          html += "<div class='form-group has-error'>"
          html += form.label(attribute, "#{human_attribute_name} #{obj.errors[attribute].first}".html_safe, :class => "control-label")
        else
          html += "<div class='form-group'>"
          html += form.label(attribute, "#{human_attribute_name}#{sublabel}".html_safe, :class => "control-label")
        end

        html += "<div class='well'>#{form_tag}</div></div>"
    end
  end
end