Given /(\w*) has shared the event "([^"]*)" with (\w*) (.*)$/ do |user_name, title, share_type, share_target|
  user = User.find_by_email!(username_to_email(user_name))
  with_logged_user(user) do
    event = FactoryGirl.build :event, :title => title, :user => user
    event.with = if share_type == 'team'
       "-1"
    else
      User.where(:email => share_target.split(',').map { |un| username_to_email(un) }).pluck(:id).join('|')
    end
    event.save!
  end
end

Given /I check (\d+) notifications in the application header/ do |count|
  visit current_path + "?rand=#{rand(1000)}"
  find('#notifications_counter').should have_content(count)
  visit notifications_path
end

Given /(\w+) has change event (\w+) from "([^"]*)" to "([^"]*)"/ do |user_name, field, old_value, new_value|
  user = User.find_by_email!(username_to_email(user_name))
  with_logged_user(user) do
    event = user.events.where(field => old_value).first
    raise ActiveRecord::RecordNotFound.new("Couldn't find Event with #{field}=#{old_value}") unless event
    event.send("#{field}=", new_value)
    event.save!
  end
end

Given /(\w+) has posted the message on team board "([^"]*)"/ do |user_name, message|
  user = User.find_by_email!(username_to_email(user_name))
  with_logged_user(user) do
    FactoryGirl.create :board_message, :team => user.team, :sender => user, :message => message
  end
end