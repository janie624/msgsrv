Then /iCalendar event exists with "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)/ do |title, start_date, end_date, start_time, end_time|
  calendar = RiCal.parse_string(page.text).first
  puts calendar.events.inspect
  calendar.events.each do |event|
    event.summary.should == title
  end
end