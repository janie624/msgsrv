module ApplicationHelper
  def title(page_title, show_page_title=true)
    content_for :title, page_title
    content_for :page_title, page_title if show_page_title
  end

  def flash_helper
    message = ''
    [:notice, :warning, :message, :error].each do |name|
      if flash[name]
        message << flash[name]
        message = content_tag(:div, content_tag(:span, message) + content_tag(:a, 'x', :class => 'close'),  :class => "alert-box #{name}" )
      end
      flash[name] = nil;
    end
    message
  end

  def profiles_path(*args)
    users_profile_path(*args)
  end
end
