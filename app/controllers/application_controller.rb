class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :set_layout
  before_filter :set_locale

  helper_method :days_to_array
  helper_method :time2str
  helper_method :date2str
  helper_method :expand_groups

  rescue_from(ActiveRecord::RecordNotFound) { render file: 'public/404.html', status: 404 }

  def set_locale
    I18n.locale = I18n.default_locale
  end

  def days_to_array(event)
    eval("[#{event.days}]")
  end

  def time2str(t)
    t.nil? ? '' : Time.parse(t.to_s).strftime("%I:%M %p")
  end

  def date2str(t)
    t.nil? ? '' : Time.parse(t.to_s).strftime("%B %eth, %Y")
  end

  def expand_groups(ids)
    ids.map do |id|
      if id.starts_with?('group')
        RecipientGroup.find_all_by(id).map do |group|
          group.users(current_user)
        end
      else
        User.find_by_id id
      end
    end.flatten.compact.uniq
  end


private

  def set_layout
    return false if request.xhr?
    'application'
  end

  def after_sign_out_path_for(resource)
    home_index_path#root_path
  end

end
