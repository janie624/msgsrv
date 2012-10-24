Given /I have added user (\w*) to aggregation/ do |username|
  token_input "sources_autocomplete", :with => username  unless username.blank?
  wait_for_ajax
end

When /I have navigated to "Master Calendar" for (.*)$/ do |date|
  visit master_calendar_events_path(:anchor => Date.parse(date).to_s)
end

When /I look at 30min block/ do

end

Then /I don't see events in calendar/ do
  page.should_not have_css('.fc-event')
end

Then /I see (\d+) (event|events) in calendar/ do |count, _|
  page.should have_css('.fc-event', :count => count)
end

