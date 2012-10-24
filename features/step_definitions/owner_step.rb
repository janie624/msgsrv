### UTILITY METHODS ###

def current_path
  URI.parse(current_url).path
end

Given /^(?:(I|users|admin|owner|coach|student))? added (\d+) (.*)$/ do |user, num, item|
  FactoryGirl.create_list item.singularize, num.to_i
end

Given /^(?:(I|users|admin|owner|coach|student|<(.*)>))? added (.*) as following:$/ do |user, email, item, table|
  eval("@#{item.pluralize} = []")
  table.hashes.each do |row|
    create_string = "@#{item} << FactoryGirl.create(:#{item.singularize}"
    for col_num in (0..(row.length - 1)) do
      p_item = row.keys[col_num].gsub(/\s/, '_').downcase
      p_value = row.values[col_num].strip

      if p_item == "school" || p_item == "team"
        if p_value != ''
          p_items = p_item.pluralize
          index = eval("@#{p_items}.index{|x| x.name == '#{p_value}'}")
          create_string += ", #{p_item}: @#{p_items}[#{index}]"
        else
          create_string += ", #{p_item}: nil"
        end
      else
        create_string += ", #{p_item}: '#{p_value}'"
      end
    end
    create_string += ", user_id: #{User.find_by_email(email).id}" if (email && !User.find_by_email(email).nil?)
    create_string += ")"
    eval(create_string)
  end
end

Given /^(?:(I|users|admin|owner|coach|student))? updated (.*) as following:$/ do |user, item, table|
  table.hashes.each do |row|
    if item == "profiles" && !User.find_by_email(row.values[0].strip).nil?
      profile = User.find_by_email(row.values[0].strip).profile
      for col_num in (1..(row.length - 1)) do
        p_item = row.keys[col_num].downcase
        p_value = row.values[col_num].strip
        eval("profile.#{p_item.gsub(/\s/, '_').downcase} = '#{p_value}'") if (!p_value.nil? && p_value != '')
      end
      profile.save!
    end
  end
end

Given /^(?:(I|users|admin|owner|coach|student))? asigned (\d+) (.*) belongs to (.*) (\d+)$/ do |user, num, item, b_item, b_num|
  eval("@#{item} = FactoryGirl.create_list :#{item.singularize}, num.to_i, #{b_item}: @#{b_item.pluralize}[b_num.to_i - 1]")
end

When /^I sign in as (.*)$/ do |user|
  visit '/sign_in'
  fill_in "Email", :with => @owner[:email]
  fill_in "Password", :with => @owner[:password]
  click_button "Sign in"
end

When /^I click "([^\"]*)" tab$/ do |tab|
  click_on(tab)
end

When /^I click "([^\"]*)" button$/ do |btn_name|
  ((btn_name == "Submit") || (btn_name == "Continue") || (btn_name == "Search") || (btn_name == "Save")) ? 
    click_button(btn_name) : click_link(btn_name) 
end

When /^I input(?: "([^\"]*)")? information as following:$/ do |item, table|
  table.hashes.each do |row|
    for col_num in (0..(row.length - 1)) do
      item_name = item ? (item.downcase + '_') : ''
      item_name += row.keys[col_num].gsub(/\s/, '_').downcase
      fill_in item_name, :with => row.values[col_num].strip
    end
  end
end

When /^I select "([^\"]*)" from "([^\"]*)"(?: for "([^\"]*)")?$/ do |item, list_name, list_for|
  list_name = list_name.gsub(/\s/, '_').downcase
  list_name = (list_name.split('_').length > 1) ? list_name : (list_name += "_id")
  list_for = list_for + "_" if list_for
  page.select(item, :from=> "#{list_for}#{list_name}")
end

When /^I click "([^\"]*)" in the list$/ do |locator|
  within("table") do
    page.find_link(locator).click()
  end
end

When /^I confirm popup$/ do
  page.driver.browser.switch_to.alert.accept    
end

When /^I dismiss popup$/ do
  page.driver.browser.switch_to.alert.dismiss
end

Then /^I should be on (.*)$/ do |page|
  within('head title') { page.should_not have_content('Access Denied') }
  current_path.should eq (path_to(page))
end

Then /^I should see "([^\"]*)"$/ do |key|
  page.should have_content key
end

Then /^I see (\d+) (.*) in the list$/ do |num, item|
  lock = false
  within('tr', :text => "Total #{item.capitalize}:") do
    page.should have_content "#{num}"
    lock = true
  end
  lock.should be_true
end

Then /^I see (\d+) today's new events$/ do |num|
  lock = false
  within('tr', :text => "Today's new events:") do
    page.should have_content "#{num}"
    lock = true
  end
  lock.should be_true
end

Then /^I should see the "(.*?)" table as following:$/ do |table_id, table|
  table_id = table_id.downcase.gsub(/ /, "_")
  row_num = 0
  table.hashes.each do |row|
    row_num += 1
    for col_num in (1..row.length) do
      val = row.values[col_num - 1].strip
      if val.split('/').length > 1
        val.split('/').each do |sub_val|
          if !sub_val.nil? && sub_val != ''
            within("table tr[#{row_num}]/td[#{col_num}]") do
              page.should have_content sub_val.strip
            end
          end
        end
      elsif val.include?('png') || val.include?('jpg') || val.include?('bmp')
        page.find("table tr[#{row_num}]/td[#{col_num}]/img")['src'].to_s.should have_content val
      elsif val != ''
        page.find("table tr[#{row_num}]/td[#{col_num}]").text.to_s.strip.should eq val
      end
    end
  end
  page.has_selector?('table tr', :count => row_num + 1).should be_true if table_id != "user_list" && table_id != "section"
end

Then /^I should see the "(.*?)" as following:$/ do |table_id, table|
  page.should have_content table_id
  table.hashes.each do |row|
    for col_num in (0..(row.length - 1)) do
      page.should have_content "#{row.keys[col_num]}"
      page.should have_content "#{row.values[col_num]}"
    end
  end
end

Then /^I should( not)? see "([^\"]*)" text box(?: filled with "([^\"]*)")?$/ do |negate, name, key|
  expectation = negate ? :should_not : :should
  if page.has_selector?("label", :text => name)
    key ? field_labeled(name).value.gsub(/\n/, '').send(expectation) == key : field_labeled(name).value.send(expectation, be_blank)
  else
    name = name.gsub(/\s/, '_').downcase
    key ? page.find("input##{name}").value.send(expectation) == key : page.find("input##{name}").value.send(expectation, be_blank)
  end
end

Then /^I should( not)? see "([^\"]*)" (button|tab|link)$/ do |negate, text, item|
  lock = false
  lock = (text == "Submit" || text == "Save" ) ? 
          page.has_selector?('input', :type => "submit", :value => text) : 
          (page.has_selector?('a', :text => text) || page.has_selector?('button', :text => text)) 
  lock.should (negate ? be_false : be_true)
end

Then /^I should see popup like "([^\"]*)"$/ do |text|
  page.driver.browser.switch_to.alert.text.should eq(text)
end

Then /^"([^\"]*)" should( not)? be an option for "([^\"]*)"(?: within (.*))?$/ do |value, negate, field, selector|
  lock = false
  field_id = field.gsub(/\s/, '_').downcase
  field_id = (field_id.split('_').length > 1) ? field_id : (field_id += "_id")
  selector = selector + "_" if selector
  within("select##{selector}#{field_id}") do
    lock = page.text.include?(value)
  end
  lock.should (negate ? be_false : be_true)
end

Then /^I should( not)? see "(.*?)" select options(?: within (.*))?$/ do |negate, list_name, list_for|
  field_id = list_name.gsub(/\s/, '_').downcase
  field_id = (field_id.split('_').length > 1) ? field_id : (field_id += "_id")
  if list_for
    field_id = "#{list_for.downcase}_#{field_id}"
  end
  expectation = negate ? :should_not : :should
  page.send(expectation, have_selector("select##{field_id}"))
end

Then /^I should( not)? see "(.*?)" section$/ do |negate, key|
  if negate
    page.has_selector?(:xpath, ".//div[@id=#{key} and @style='display: none;']")
  else
    page.has_selector?(:xpath, ".//div[@id=#{key} and @style='display: block;']")
  end
end

Then /^I should see my photo$/ do
  page.has_selector?("img", :src => "/assets/missing.png") if @user.profile.photo.nil?
end
