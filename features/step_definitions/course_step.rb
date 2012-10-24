Then /^I should see "(.*?)" radio option(?: '(checked|unchecked)')?(?: within "(.*?)")?$/ do |item, status, name|
  within("tr", :text => name) do
    page.should have_content item
    val = (item == "All") ? '' : item.upcase
    if status == 'checked'
      page.should have_selector("input#status_#{val}", :type => "radio", :value => val, :checked => "checked")
    else
      page.should have_selector("input#status_#{val}", :type => "radio", :value => val) 
    end
  end
end

Then /^I should see "(.*?)" check box(?: '(checked|unchecked)')?(?: within "(.*?)")?$/ do |item, status, name|
  within("tr", :text => name) do
    page.should have_content item
    if status == 'checked' 
      page.should have_selector("input#section_days_", :type => "checkbox", :value => item, :checked => "checked")
    else
      page.should have_selector("input#section_days_", :type => "checkbox", :value => item)
    end
  end
end

When /^I choose "(.*?)" within "(.*?)"$/ do |item, name|
  val = (item == "All") ? '' : item.upcase
  within("tr", :text => name) do
    page.choose("status_#{val}") if name == "Search Type"
  end
end

When /^I check "(.*?)" within "(.*?)"$/ do |item, name|
  within("tr", :text => name) do
    page.check("section_days_", :value => item) if name == "Day(s)"
  end
end