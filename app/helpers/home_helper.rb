module HomeHelper
  def partial(current_user_rolename)
    return "#{current_user_rolename}_index"
  end

  def date_custom(t)
    t.nil? ? '' : Time.parse(t.to_s).strftime("%b.%eth, %Y")
  end
end
