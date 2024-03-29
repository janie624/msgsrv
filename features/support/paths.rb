﻿module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the static page/
      '/'
      
    when /the home\s?page/
      '/home'

    when /the sign up page/
      '/sign_up'

    when /the sign in page/
      '/sign_in'
    
    when /the events index page/
      '/events'
    when /the new event page/
      '/events/new'
      
    when /the news page/
      '/news'

    when /^(.*)'s profile show page$/i
      '/profiles/' + User.find_by_email($1).profile.id.to_s
      
    when /^(.*)'s profile edit page$/i
      '/profiles/' + User.find_by_email($1).profile.id.to_s + '/edit'
      
    when /the courses index page/
      '/courses'
      
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
