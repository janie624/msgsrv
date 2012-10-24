Given /the following team members/ do |table|
  table.hashes.each do |row|
    team = Team.find_by_name(row["team"])
    team ||= FactoryGirl.create :team, :name => row["team"]
    user = FactoryGirl.build :student, :team => team, :email => username_to_email(row[:user]), :first_name => row[:user]
    if row.has_key? "role"
      parse_user_roles(user, row["role"])
    end
    user.save!
  end
end

Given /events exists/ do |table|
  table.hashes.each do |row|
    user = User.find_by_email!(username_to_email(row["owner"]))
    with_logged_user(user) do
      FactoryGirl.create :event, :user => user,
                                 :from => Date.parse(row["date"]),
                                 :to => Date.parse(row["date"]),
                                 :starts_at => row["starts_at"],
                                 :ends_at => row["ends_at"],
                                 :title => row["title"]
    end
  end
end

Given /I have selected "([^"]*)" page from "([^"]*)"/ do |link, scope|
  within("##{scope.gsub(' ', '_').tableize.singularize}") do
    click_on link
  end
end

When /log in as (\w*)$/ do |user|
  visit new_user_session_path
  fill_in 'Email', :with => username_to_email(user)
  fill_in "Password", :with => 'password'
  click_button "Sign in"
  u = User.find_by_email!(username_to_email(user))
  Authorization.current_user = u
end

When /log off as (\w*)$/ do |user|
  click_on "Sign Out"
end


Then /see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /I do not see "([^"]*)"/ do |text|
  page.should_not have_content(text)
end

Then /see data "([^"]*)"/ do |text|
  text.split(',').each do |data|
    page.should have_content(data)
  end

end

Given /checked .*? "([^"]*)" checkbox/ do |checkbox|
  check(checkbox)
end

Given /clicked "([^"]*)"/ do |subject|
  click_on subject
end

Given /role of (\w*) is "([^"]*)/ do |user, roles|
  u = User.find_by_email!(username_to_email(user))
  parse_user_roles(u, roles)
  u.save!
end

Given /(name|email|first name|last name) of (\w+) is "([^\"]*)/ do |field, user, value|
  u = User.find_by_email!(username_to_email(user))
  u.send("#{field.gsub(' ', '_').tableize.singularize}=", value)
  u.save!
end

Given /(\w+) affiliated to (\w+)/ do |user, team|
  u = User.find_by_email!(username_to_email(user))
  team = Team.find_by_name(team)
  team ||= FactoryGirl.create :team, :name => team
  u.team = team
  u.save!
end

Given /(\w+) has event of type "([^"]*)" on (.+?) from (.+?) to (.+?)$/ do |user, category, date, start_time, end_time|
  u = User.find_by_email!(username_to_email(user))
  with_logged_user(u) do
    FactoryGirl.create :event, :category_id => Event.categories[category],
                               :from => date,
                               :to => date,
                               :starts_at => start_time,
                               :ends_at => end_time,
                               :user => u
  end
end
