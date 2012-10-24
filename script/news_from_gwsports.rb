require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'mysql'


logfile = File.open("log.html", "w")

host = "127.0.0.1"
user = "root"
passwd = ""
dbname = "project_development"
tblname = "news"

db_connector = Mysql.new(host, user, passwd)
db_connector.select_db(dbname)
	
url = "http://www.gwsports.com/index-main.html#"
doc = Nokogiri::HTML(open(url))

doc.xpath('//div[@id="sec-headlines-wrap"]').each do |a|
	category = a.xpath('a/div[@class="sec-headlines-date"]/text()').to_s.strip
	
	added_date = a.xpath('a/div[@class="sec-headlines-date"]/span/text()').to_s.strip	
	tmp_date = added_date.split('/')
	added_date = "#{tmp_date[2]}-#{tmp_date[0]}-#{tmp_date[1]}"
	
	sub_url = "#{url.to_s[0..-18]}#{a.xpath('a').first['href']}"
	sub_doc = Nokogiri::HTML(open(sub_url))
	sub_doc.encoding = 'utf-8'

	title = sub_doc.xpath('//div[@class="storyheadline"]').text.strip.gsub(/\"/, '\\\"')
	sub_title = sub_doc.xpath('//div[@class="storyteaser"]').text.strip.gsub(/\"/, '\\\"')
	contents = sub_doc.xpath('//div[@id="Content"]').first.to_s.gsub(/\"/, '\\\"').to_s
	puts title
	
	img_url = sub_doc.xpath('//table/tr[1]/td[1]/table/tr[1]/td[2]/img')
	img_src = "none"
	img_src = img_url.first['src'] if img_url.length != 0
	
	image_id = 0
	img_description = ""
	
	if img_src != "none" then
		r = Random.new
		image_id = r.rand(1000...9000)
		image_name = "#{image_id}.jpg"
		image_save_folder = "..\/app\/assets\/images\/news"
		image_save_path = "#{image_save_folder}\/#{image_name}"
		
		agent = Mechanize.new
		agent.pluggable_parser.default = Mechanize::Download
		agent.get("#{img_src}").save("#{image_save_path}")
		
		img_description = sub_doc.xpath('//table/tr[1]/td[1]/table/tr[1]/td[2]/span[@class="photocaption"]').text.strip.gsub(/\"/, '\\\"')
	end
	
	query = "INSERT INTO " + tblname + " (`title`, `subtitle`, `category`, `content`, `image_id`, `image_description`, `added_date`, `created_at`, `updated_at`) VALUES "
	query = query + "(\"" + title.to_s
	query = query + "\",\"" + sub_title.to_s
	query = query + "\", '" + category
	query = query + "', \"" + contents
	query = query + "\", '" + image_id.to_s
	query = query + "', \"" + img_description.to_s
	query = query + "\", '" + added_date
	query = query + "', '0000-00-00 00:00:00', '0000-00-00 00:00:00')"
	
	db_connector.query(query);
end
#end
