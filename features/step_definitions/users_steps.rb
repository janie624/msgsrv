When /^I logged in(?: as (admin|owner|coach|student))?(?: with id (\d+))?(?: with email "([^\"]*)")?$/ do |role, id, email|
  if email
    index = @users.index{|x| x.email == email}
    @user = @users[index]
  elsif role == 'owner'
    @user = User.where("role_id = ?", 1).first
    @user.password = 'athletetrax'
  else
    school = FactoryGirl.create :school
    if role == 'admin'
      @user = id ? FactoryGirl.create(role.to_sym, school: school, team: nil, id: id) : FactoryGirl.create(role.to_sym, school: school, team: nil)
    else
      team = FactoryGirl.create :team, school: school
      @user = id ? FactoryGirl.create(role.to_sym, school: school, team: team, id: id) : FactoryGirl.create(role.to_sym, school: school, team: team)
    end
  end
  visit '/users/sign_in'
  fill_in 'user_email', :with => @user.email
  fill_in 'user_password', :with => @user.password
  click_button "Sign in"
end

Given /^I do not have user account$/ do
  visit '/users/sign_out'
end

Given /^I added test events$/ do
  yesterday = Date.today - 1.days
  today_date = Date.today
  tommorrow = Date.today + 1.days
  after_2_date = Date.today + 2.days
  after_3_date = Date.today + 3.days
  after_4_date = Date.today + 4.days
  after_5_date = Date.today + 5.days
  @events = []
  @events[0] = FactoryGirl.create(:event, title: 'Academics', location: 'Newyork', from: yesterday, to: yesterday, user_id: 3)
  @events << FactoryGirl.create(:event, title: 'Athletics', location: 'Michigan', from: today_date, to: today_date, user_id: 3)
  @events << FactoryGirl.create(:event, title: 'Extracurricular', location: 'New Jersey', from: tommorrow, to: tommorrow, user_id: 3)
  @events << FactoryGirl.create(:event, title: 'Personal', location: 'Ohio', from: after_2_date, to: after_2_date, user_id: 3)
  @events << FactoryGirl.create(:event, title: 'Chinese', location: 'Newyork', from: after_3_date, to: after_3_date, user_id: 3)
  @events << FactoryGirl.create(:event, title: 'Economics', location: 'Michigan', from: after_4_date, to: after_4_date, user_id: 3)
  @events << FactoryGirl.create(:event, title: 'Physics', location: 'Newyork', from: after_5_date, to: after_5_date, user_id: 5)
end

Then /^I see the sign in page with notice$/ do
  page.should have_content "You need to sign in or sign up before continuing."
end

Then /^I should see welcome message$/ do
  page.should have_content "Welcome to AthleteTrax, #{@user.first_name} #{@user.last_name}"
end

Then /^I should see "(.*?)" list as following:$/ do |name, table|
  page.should have_content name
  row_num = 0
  table.hashes.each do |row|
    row_num += 1
    row_data = page.find(:xpath, ".//dl[#{row_num}]").text
    for col_num in (0..(row.length - 1)) do
      row_data.should have_content "#{row.values[col_num]}"
    end
  end
  page.has_selector?(:xpath, ".//dl[#{row_num + 1}]").should be_false
end

Then /^I should see the "(.*?)" table$/ do |name|
  page.should have_content name
  lock = false
  (1..5).each do |i|
    within(:xpath, ".//table/tbody/tr[#{i}]") do
      page.should have_content i.to_s
      page.should have_content @events[i].from.strftime("%b.%eth, %Y")
      page.should have_content '01:00 PM ~ 02:00 PM'
      page.should have_content @events[i].title
      page.should have_content @events[i].location
      lock = true
    end
  end
  lock.should be_true
end
