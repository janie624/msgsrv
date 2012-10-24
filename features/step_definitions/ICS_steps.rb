When /I post the message "([^\"]*)"/ do |message|
  click_on "New board message"
  wait_for_ajax
  wait_until { find("#modal_board_message").visible? }
  within("#new_board_message") do
    fill_in "board_message_message", :with => message
    click_on "Send"
    wait_for_ajax
  end
end


Given /I have chosen (\w*) as recipient/ do |username|
  token_input "message_recipient_ids", :with => username
end

Given /I have entered "([^\"]*)" as message (\w*)/ do |value, field|
  within('#new_message') do
    fill_in "message_#{field}", :with => value
  end
end

Then /I see "([^\"]*)" as my first message in the list/ do |content|
  recipient, subject, body = content.split('|')
  within('.message-table') do
    first('tr.message-item') {
      find('td.recipients').shuold have_content(recipient)
      find('td.subject').shuold have_content(subject)
      find('td.body').shuold have_content(body)
    }
  end
end