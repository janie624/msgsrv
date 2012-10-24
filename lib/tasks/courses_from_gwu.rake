$total_count = 0		# total count of items

$terms = ["FALL 2012", "SPRING 2012"]
$term_ids = ["201203", "201201"]

def insert_section_to_table(item, subject)
	from = to = start_time = end_time = ''
	
	if (item['from_to'] != '') then
		result = item['from_to'].split(' - ')
		from = result[0]
		to = result[1]
		result = from.split('/')
		from = "20" + result[2] + "-" + result [0] + "-" + result[1]
		result = to.split('/')
		to = "20" + result[2] + "-" + result [0] + "-" + result[1]
	end
	
	if (item['time'] != '') then
		result = item['time'].split(' - ')
		start_time = get_regular_time(result[0])
		end_time = get_regular_time(result[1])
	end
	
	t = Time.now
	now = t.strftime("%y-%m-%d %H:%M:%S")
	
	day_full = ""

	for i in (0..item['day'].length - 1)
		case (item['day'][i])
			when 'M' then
				day_full = "#{day_full}, 1"
			when 'T' then
				day_full = "#{day_full}, 2"
			when 'W' then
				day_full = "#{day_full}, 3"
			when 'R' then
				day_full = "#{day_full}, 4"
			when 'F' then
				day_full = "#{day_full}, 5"
		end
	end

	day_full = day_full[2..-1]
	
	section = {}
	section['course_id'] = Course.where("subject = ?", subject).first.id
	section['crn'] = item['crn']
	section['day'] = day_full
	section['start_time'] = start_time
	section['end_time'] = end_time
	section['from'] = from
	section['to'] = to
	section['description'] = item['description']
	section['status'] = item['status']
	section['sect'] = item['sect']
	section['credit'] = item['credit']
	section['instructor'] = item['instructor']
	section['bldg'] = item['bldg']
	section['fee'] = item['fee']
	
	new_record = Section.find_or_create_by_crn(item['crn'])
	new_record.update_attributes(section)
end

def insert_department_to_table(abbrev, title)
	department = {}
  department['title'] = title
  department['abbrev'] = abbrev
  department['school_id'] = 1

	new_record = Department.find_or_create_by_abbrev(abbrev)
  new_record.update_attributes(department)
end

def insert_course_to_table(row, category, term)
	course = {}
	course['title'] = row.at_xpath('tr[1]/td[5]/text()').to_s.strip.gsub(/\'/, '"').gsub(/&amp;/, "&")
	course['subject'] = category.to_s + row.at_xpath('tr[1]/td[3]/a/text()').to_s.strip
	course['term'] = term
	course['comment'] = row.xpath('tr[2]/td[1]/text()').to_s.strip.gsub(/(\t|\r)/, '')
	
	course['course_attributes'] = ""
	row.xpath('tr[2]/td[1]/div/table/tr').each do |p|
		course['course_attributes'] += (p.xpath('td[1]/text()').to_s.strip + p.xpath('td[2]/text()').to_s.strip + "|")
	end
	
  course['department_id'] = Department.where("abbrev = ?", category.to_s).first.id
	course['fee'] = row.xpath('tr[3]/td[1]/table[1]/tr[1]/td[2]/text()').to_s.strip.gsub(/&nbsp;/,'')
	
	new_record = Course.find_or_create_by_subject(course['subject'])
  new_record.update_attributes(course)
	
	return course['subject']
end

############################################
# parse the html content from table row
############################################
def parse_html_with_row(rows, category, term)
	item = {}

	rows.collect do |row|
		item = get_class_item(row.xpath('tr[1]').first)
		
		if (item['crn'] != '')
			subject = insert_course_to_table(row, category, term)
			insert_section_to_table(item, subject)
						
			row.xpath('tr[@class="tableRowDD1Font" and @align="center"]').each do |sub_row|
				item = get_class_item(sub_row)
				insert_section_to_table(item, subject)
			end
			
			$total_count = $total_count + 1
		end
	end
end

def get_class_item(row)
	item = {}
	[
		['status', 			'td[1]/text()'],
		['crn', 				'td[2]/text()'],
		['sect', 				'td[4]/text()'],
		['description',	'td[5]/text()'],
		['credit', 			'td[6]/text()'],
		['instructor', 	'td[7]/text()'],
		['bldg', 				'td[8]/text()'],
		['day', 				'td[9]/text()'],
		['from_to',			'td[10]/text()'],
	].each do |name, xpath|
		case (name)
			when "bldg" then
				item[name] = row.at_xpath('td[8]/a/text()').to_s.strip + row.at_xpath(xpath).to_s.strip
			when "day" then
				day_flag = 0
				item[name] = item['time'] = ''
				row.xpath(xpath).each do |link|
					if day_flag == 0 then
						item[name] = link.content.to_s.strip
						day_flag = 1
					else
						item['time'] = link.content.to_s.strip
					end
				end
			else
				item[name] = row.at_xpath(xpath).to_s.strip
		end
		item[name] = item[name].gsub(/\'/, '"')
	end
	return item
end

def get_regular_time(atime)
	ahour = atime[0,2].to_i
	amin = atime[3,2]
	
	if (atime[-2,2] == "PM") && (atime[0,2] != "12") then
		ahour = ahour + 12
	end
	
	t = Time.new(1999, 01, 01, ahour, amin)
	return now = t.strftime("%H:%M:%S")
end

# Variables...

task :courses_from_gwu => :environment do
	#(0..1).each do |i|
		#term = $terms[i]
		term = $terms[0]
		#term_id = $term_ids[i]
		term_id = $term_ids[0]
		base_url = "http://my.gwu.edu/mod/pws/subjects.cfm?campId=1&termId=#{term_id}"
		sub_base_url = "http://my.gwu.edu/mod/pws/courses.cfm?campId=1&termId=#{term_id}"
		
		doc = Nokogiri::HTML(open(base_url))
		department_table = doc.xpath('//table[@class="bodyFont"]').first
		departments = department_table.xpath('//table[@class="bodyFont"]/tr[2]/td/ul/li/a')

		departments.each do |t|
			#t = departments.first
			title = t.text().to_s
			abbrev = t['href'][/subjId=(.*)/, 1]
			insert_department_to_table(abbrev, title)

			total_page = 15	    # limit number for browsable pages
			
			for pagenum in 1..total_page
				#pagenum = 1
				#genenrate the url to scrap the data
				get_url = sub_base_url + '&subjId=' + abbrev + '&pageNum=' + pagenum.to_s()

				# get html page
				sub_doc = Nokogiri::HTML(open(get_url))
				
				# if it's empty page, you can pass this Subject scrap
				# analyze html page and put the data into the hash
				rows = sub_doc.xpath('//div[@class="bodyFont"]/../table')

				# check if this page is empty page.
				if (rows.length == 1) then
					break
				else
					printf "subject=%s, pagenum=%i\n", abbrev, pagenum
				end
		   		
		   	# get data from the parsed html page
				parse_html_with_row(rows, abbrev, term)
			end
		end
	#end

	puts "\nThanks for using this script! total=#{$total_count} :)"
end
