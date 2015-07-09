# -*- encoding : utf-8 -*-
# connect to the MySQL server
def get_db_connection(env)
  $db_connection_established = false
  site_config = YAML::load(File.open("#{File.dirname(__FILE__)}/site_properties.yml"))
  db_config = YAML::load(File.open("#{File.dirname(__FILE__)}/database.yml"))
  $AGENT_ENV = env
  config = db_config[env]
  $site_details = site_config[env]
  begin
    # connect to the MySQL server
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Base.connection
    $db_connection_established = true
    # get server version string and display it
    #~ puts "Server version: " + $dbh.get_server_info
    $logger.info 'Mysql connection established'
    #~ return dbh
  rescue Mysql::Error => e
    $logger.error "Error code: #{e.errno}"
    $logger.error "Error message: #{e.error}"
    $logger.error "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
  end
end
