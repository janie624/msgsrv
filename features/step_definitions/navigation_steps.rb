Given /navigated to "Send Message"/ do
  visit messages_path
  click_on "New message"
  wait_for_ajax
end

Given /navigate to "Message Inbox"/ do
  visit messages_path
end

Given /navigate to "User Directory"/ do
  visit users_path
end

Given /I navigate to "Message History, Sent"/ do
  visit messages_path
  click_on "Sent"
  wait_for_ajax
end

Given /I navigate to first event/ do
  visit events_path
  within('#event_list .listField') do
    find("a").click
  end
end

Given /I have navigated to Calendar/ do
  visit calendar_events_path
end