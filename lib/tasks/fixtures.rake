
#############################
#	Main process
########################

task :test_fixtures => :environment do
  ActiveRecord::Base.connection.tables.each do |table_name|
    i = "000" 
    yaml_file = File.open("spec\/fixtures\/#{table_name}.yml", "w")
    
    sql = "SELECT * FROM %s" 
    data = ActiveRecord::Base.connection.select_all(sql % table_name)
      yaml_file.write data.inject({}) { |hash, record|
        hash["#{table_name}_#{i.succ!}"] = record
        hash
      }.to_yaml 
  end
end
