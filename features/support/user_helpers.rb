module UserHelpers
  def username_to_email(name)
    "#{name.downcase}@example.com"
  end

  def parse_user_roles(u, roles)
    roles.split('-').map(&:strip).each do |role_name|
      role = Role.find_by_name(role_name.downcase)
      if role
        u.role = role
        if role.name == 'admin' || role.name == 'owner'
          u.team = nil
        end
      elsif role_name == "Captain"
        u.profile.captain_id = 2
      elsif Profile.ClassValue.include?(role_name)
        u.profile.class_id = Profile.ClassValue[role_name]
      else
        raise "Incorrect role value #{role_name}"
      end
    end
  end

  def with_logged_user(u)
    raise ArgumentError unless block_given?
    old_user = Authorization.current_user
    Authorization.current_user = u
    yield
    Authorization.current_user = old_user
  end
end
World(UserHelpers)