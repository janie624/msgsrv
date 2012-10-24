Given /^I have follow event(?: assigned from (.*))?:$/ do |creator_role, table|
  @all_members = [] if @all_members.nil?
  @events = [] if @events.nil?
  user = @user
  team = (user.role_id != 2) ? user.team : FactoryGirl.create(:team)
  
  if !creator_role.blank?
    if creator_role != 'admin'
      user = FactoryGirl.create creator_role.to_sym, team: team, school: @user.school
    else
      user = FactoryGirl.create creator_role.to_sym, team: nil, school: @user.school
    end
    @all_members << user
  end
  
  table.hashes.each do |params|
    event_params = {:user => user}
    event_params[:category_id] = Event.categories[params[:category]]
    event_params[:title] = params[:title]
    event_params[:location] = params[:location]
    event_params[:description] = params[:description]
    event_params[:starts_at] = params[:starts_at]
    event_params[:ends_at] = params[:ends_at]
    event_params[:from] = params[:from]
    event_params[:to] = params[:to]
    event_params[:repeat] = params[:repeat]
    event_params[:tba] = params[:tba]
    event_params[:allday] = params[:allday]
    event_params[:with] = params[:with] == '-1' ? -1 : "|#{@user.id}|" + @all_members.select{|x|params[:with].split(',').include? "#{@all_members.index(x)+1}"}.map(&:id).join('|') + '|'
    
    @events << FactoryGirl.create(:event, event_params)
  end
end

Then /^I see the event edit page with follow values:$/ do |table|
  params = table.hashes.first
  page.find('#event_title').value.should eq params[:title]
  page.find('#event_category_id').value.should eq "#{Event.categories[params[:category]]}"
  page.find('#event_location').value.should eq params[:location]
  page.find('#event_description').value.should eq params[:description]
  page.find('#event_from').value.should eq params[:from]
  page.find('#event_to').value.should eq params[:to] if page.find('#event_to').visible?
  page.find('#event_starts_at').value.should eq params[:starts_at] if page.find('#event_starts_at').visible?
  page.find('#event_ends_at').value.should eq params[:ends_at] if page.find('#event_ends_at').visible?
end

Given /^I have (\d+) (.*) events$/ do |num, type|
  @events = [] if @events.nil?
  category = (type == 'Course') ? 1 : Event.categories[type]
  num.to_i.times do
    section = (type == 'Course') ? (FactoryGirl.create :section) : nil
    @events << FactoryGirl.create(:event, user: @user, category_id: category, course_id: (type == 'Course') ? section.id : 0) 
  end
end

Given /^There are (\d+) (.*) members (as captain )?in (.*) team$/ do |num, type, captain, team_name|
  @all_members = [] if @all_members.nil?
  team = (team_name == 'my') ? @user.team : Team.where(:name => team_name).try{|x| x.blank? ? FactoryGirl.create(:team, :name => team_name) : x.first} 
  if team.nil? or @user.school.nil?
    raise "Wrong test case, user must have a team belongs in any school"
  else
    if Profile.ClassValue.keys.include? type
      num.to_i.times {@all_members << FactoryGirl.create(:student, school: @user.school, team: team, profile: FactoryGirl.create(:profile, class_id: Profile.ClassValue[type], captain_id: captain ? 2 : 1))}
    else
      @all_members += FactoryGirl.create_list(type.to_sym, num.to_i, school: @user.school, team: team)
    end
  end
end

Given /^There are (\d+) admin members in my school$/ do |num|
  @all_members = [] if @all_members.nil?
  
  if @user.role_id != 2
    raise "Wrong test case, user must have a team belongs in any school"
  else
    @all_members += FactoryGirl.create_list(:admin, num.to_i, school: @user.school, team: nil)
  end
end

Given /^I have (\d+) (.*) events assigned from (.*)$/ do |num, type, role|
  @events = [] if @events.nil?
  if role.downcase != 'admin'
    user = FactoryGirl.create role.to_sym, team: @user.team, school: @user.school
  else
    user = FactoryGirl.create role.to_sym, team: nil, school: @user.school
  end
  @events += FactoryGirl.create_list :event, num.to_i, user: user, with: "|#{@user.id}|#{user.id}|", category_id: Event.categories[type]
end

When /^I delete (\d+)th event$/ do |i|
  page.find(:xpath, "//tr[#{i}]/td[6]/dd/a[2]").click
  @events.delete_at(i.to_i - 1)
end

When /^I remove (\d+)th course$/ do |i|
  page.find(:xpath, "//tr[#{i}]/td[6]/dd/a").click
  @events.delete_at(i.to_i - 1)
end

When /^I click (.*) link$/ do |text|
  page.find_link(text).click
end

When /^I click title of the event$/ do
  @event = @events.sample
  page.find_link(@event.title).click
end

Then /^I see the event detail$/ do
  page.find('tr', :text => 'Title:').text.should be_include(@event.title)
  page.find('tr', :text => 'Location:').text.should be_include(@event.location)
  page.find('tr', :text => 'Description:').text.should be_include(@event.description)
  page.find('tr', :text => 'Type:').text.should be_include(Event.categories.invert[@event.category_id])
  page.find('tr', :text => 'Duration:').text.should be_include(@event.from.strftime('%B %eth, %Y'))
  page.find('tr', :text => 'Duration:').text.should be_include(@event.to.strftime('%B %eth, %Y'))
  if (@event.allday == true)
    page.find('tr', :text => 'Time:').text.should be_include('Allday')
  elsif(@event.tba == true)
    page.find('tr', :text => 'Time:').text.should be_include('TBA')
  else
    page.find('tr', :text => 'Time:').text.should be_include(@event.starts_at.strftime('%I:%M %p'))
    page.find('tr', :text => 'Time:').text.should be_include(@event.to.strftime('%I:%M %p'))
  end
end

When /^I click (.*) category$/ do |ctg_name|
  @all_events = @events if @all_events.nil?
  @events = @all_events.select{|x| x.category_id == Event.categories[ctg_name]} if !@all_events.nil?
  page.find('.nav-tabs').find_link(ctg_name).click
end

Then /^I see category is selected to (.*)$/ do |ctg_name|
  page.has_select?('event_category_id', :selected => ctg_name).should == true
end

Then /^I see the (.*) category is activated$/ do |ctg_name|
  page.find('.nav-tabs').find('li', :text => ctg_name)['class'].should eq('active') 
end

Then /^I see selectable (.*)$/ do |ctgs|
  page.find('#event_category_id').text.should eq(ctgs.split(',').join)
end

Then /^I see the new event page$/ do
  find_field('event_title').should_not be_nil
  find_field('event_category_id').should_not be_nil
  find_field('event_location').should_not be_nil
  find_field('event_from').should_not be_nil
  find_field('event_to').should_not be_nil
  find_field('event_starts_at').should_not be_nil
  find_field('event_ends_at').should_not be_nil
  find_field('event_tba').should_not be_nil
  find_field('event_repeat').should_not be_nil
  find_field('event_allday').should_not be_nil
end

Then /^I see (\d+) events on index page$/ do |num|
  events = page.all(:xpath, '//tr')
  events.shift
  events = events[0..-2] # for paginate
  events.length.should eq(num.to_i)
  events.each_index do |i|
    page.find(:xpath, events[i].path + '/td[1]').text.to_i.should eq(i + 1)
    dates = page.find(:xpath, events[i].path + '/td[2]').text.split('~')
    Date.parse(dates[0].strip).should eq(@events[i].from)
    Date.parse(dates[1].strip).should eq(@events[i].to)
    time = page.find(:xpath, events[i].path + '/td[3]').text.split('~')
    time[0].strip.should eq(@events[i].starts_at.strftime("%I:%M %p"))
    time[1].strip.should eq(@events[i].ends_at.strftime("%I:%M %p"))
    page.find(:xpath, events[i].path + '/td[4]/a').text.strip.should eq(@events[i].title)
    page.find(:xpath, events[i].path + '/td[4]/a')['href'].should eq("/events/#{@events[i].id}")
    page.find(:xpath, events[i].path + '/td[5]').text.strip.should eq(@events[i].location)
    if @events[i].course_id != 0
      page.find(:xpath, events[i].path + '/td[6]/dd/a').text.strip.should eq("Remove course")
    elsif @events[i].user_id == @user.id
      page.find(:xpath, events[i].path + '/td[6]/dd/a[1]').text.strip.should eq("Edit")
      page.find(:xpath, events[i].path + '/td[6]/dd/a[2]').text.strip.should eq("Delete")
    elsif @events[i].user.role_id == 3 and @user.role_id == 3
      page.find(:xpath, events[i].path + '/td[6]').text.strip.should eq("Edit")
    elsif @events[i].user.role_id == 2 and @user.role_id == 2
      page.find(:xpath, events[i].path + '/td[6]').text.strip.should eq("Edit")
    else
      page.find(:xpath, events[i].path + '/td[6]').text.strip.should eq('')
    end
  end
end

Then /^I see category names for (.*)$/ do |role|
  case role
  when 'admin'
    c_ctgs = 'Personals'
  else
    c_ctgs = 'All,Academics,Athletics,Extracurricular,Personals'
  end
  
  lock = false;
  within ('.nav-tabs') do
    page.all(:xpath, 'li/a').map(&:text).join(',').should eq(c_ctgs)
    lock = true
  end
  lock.should be_true
end

When /^I (.*)check the (.*) option$/ do |action, target|
  if action.blank?
    check("event_#{target.downcase}")
  else
    uncheck("event_#{target.downcase}")
  end
end

Then /^I see (.*) field (.*)visible$/ do |target, visible|
  if visible.blank?
    #page.find("##{target}").visible?.should be_true
  else
    #page.find("##{target}").visible?.should be_false
  end
end

Then /^I see (.*) checkbox (.*)checked$/ do |target, checked|
  if (checked.blank?)
    page.find("#event_#{target.downcase}").should be_checked
  else
    page.find("#event_#{target.downcase}").should_not be_checked
  end
end

When /^I (.*)check the all days$/ do |check|
  if (check.blank?)
    check('day-check-1')
  else
    uncheck('day-check-1')
  end
end

Then /^7 days will be (.*)checked$/ do |status|
  if (status.blank?)
    page.all(:xpath, "//input[@name='event[days][]']").select{|x| x.checked?}.length.should eq 8
  else
    page.all(:xpath, "//input[@name='event[days][]']").select{|x| x.checked?}.length.should eq 0
  end
end

When /^I uncheck one day$/ do
  uncheck('day-check2')
end

Then /^all days will be unchecked$/ do
  page.find('#day-check-1').should_not be_checked
end

Then /^event share popup window will appear$/ do
  page.find('#members_dlg').should be_visible
end

Then /^there are (.*) options to select (.*)$/ do |values, dropdown|
  page.find("##{dropdown}_select").text.split(/\n/).join(',').should eq values
end

When /^I select (.*) from (role|team|class) drop down$/ do |value, dropdown|
  page.find("##{dropdown}_select").select(value) 
end

When /^I select (.*) from (category_id|starts_at|ends_at|from|to) drop down$/ do |value, dropdown|
  page.find("#event_#{dropdown}").select(value) if page.find("#event_#{dropdown}").visible?
end

Then /^I see (.*) members (?:of (.*) team )?in shared table$/ do |member_type, team_name|
  case member_type
  when 'no'
    members = []
  when 'All'
    members = @all_members
  when 'student'
    members = @all_members.select{|x| x.role_id == 4}
  when 'coach'
    members = @all_members.select{|x| x.role_id == 3}
  when 'admin'
    members = @all_members.select{|x| x.role_id == 2}
  when 'Captain'
    members = @all_members.select{|x| x.profile.captain_id == Profile.CaptainValue['Yes']}
  when 'Freshman'
    members = @all_members.select{|x| x.profile.class_id == Profile.ClassValue[member_type]}
  when 'Sophomore'
    members = @all_members.select{|x| x.profile.class_id == Profile.ClassValue[member_type]}
  when 'Junior'
    members = @all_members.select{|x| x.profile.class_id == Profile.ClassValue[member_type]}
  when 'Senior'
    members = @all_members.select{|x| x.profile.class_id == Profile.ClassValue[member_type]}
  else
    raise "Wrong test case, invalid member role"
  end
  
  members = members.select{|x| x.team.name == team_name} if !team_name.blank?
  
  expect_count = members.blank? ? 2 : members.count + 1
  page.all('#selected_users tr').count.should eq expect_count  
  if (members.blank?)
    page.find('#selected_users tr[2]').text.should be_include("No shared member")
  end
  
  members.each do |x|
    page.all('#selected_users tr').select{|tr|tr.find(:xpath, 'td[1]').text == "#{x.first_name} #{x.last_name}"}.count.should eq 1
  end
end

When /^I input (.*) as ("([^\"]*)")$/ do |field, value|
  fill_in "event_#{field}", :with => value if page.find("#event_#{field}").visible?
end

When /^I click OK button$/ do
  page.find_button('OK').click
end