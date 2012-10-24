Then /^I see (\d+) links - (.*) on navigation bar$/ do |num, links|
  links_array = page.find(:css, '.navbar-inner').all('a')
  links_array.length.should eq(num.to_i)
  link_texts = links_array.map{|x|x.text.strip}
  links.split(',').each do |link_text|
    link_texts.include?(link_text).should be_true
  end
end

Then /^I see my name on navigation bar$/ do
  page.find(:css, '.navbar-inner').text.include?("#{@user.first_name} #{@user.last_name}").should be_true
end
