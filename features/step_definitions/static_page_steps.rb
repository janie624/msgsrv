Then /^I see the static page$/ do
  page.should have_content 'Software Solutions for the College Sports Industry'
end

Then /^I see the home page$/ do
  page.should have_content "Welcome to AthleteTrax, #{@user.first_name} #{@user.last_name}"
end