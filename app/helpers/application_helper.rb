module ApplicationHelper
  def seo_meta_tag
    [ tag('meta', :name => 'description', :content => @meta_description),
      tag('meta', :name => 'keywords', :content => @meta_keywords)
    ].join("\n").html_safe    
  end

  def breaking_quiz_name(name)
    new_name = h(name)
    new_name = name.gsub("SONGS BY", "SONGS BY<br/>").html_safe if name.length > 31
    new_name
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class => "removeField")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => "addField")
  end

  def link_to_add_answer(name, question_index, column_index, html_options = {})
    link_to_function(name, "add_answer(this, #{question_index}, #{column_index})", html_options)
  end
  
  def f_logo_link(*options)
    fan_page     = APP_CONFIG[:facebook_page_url]
    options      = options[0] || {}
    
    options.merge!({:target => "_blank"})
    div = "<div class='f_logo_text'>BECOME OUR FAN ON FACEBOOK</div>"
    link_to image_tag("/images/f_logo.png", :class => "f_logo") + div.html_safe, fan_page, options
  end
  
  def post_content(post, options = {})
    if options[:truncate] == true
      content = truncate(post.body, :length => options[:length], :omission => options[:omission])
      simple_format(Sanitize.clean(content, Sanitize::Config::RELAXED))
    else
      simple_format(Sanitize.clean(post.body, Sanitize::Config::RELAXED))
    end
  end
  
  def clean_html(content)
    Sanitize.clean(content, Sanitize::Config::RESTRICTED)
  end
end
