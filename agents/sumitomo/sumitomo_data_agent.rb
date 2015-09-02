# -*- encoding : utf-8 -*-
require 'logger'
require 'action_mailer'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
		ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "scrape.coder@gmail.com",
  :password             => "odesk2016",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
ActionMailer::Base.view_paths= File.dirname(__FILE__)

class SumitomoMailer < ActionMailer::Base
		
def sumitomo_daily_data_email(fi_name,attach)
		$logger.info  "Sending email.."
		$logger.info "Sending email.."
		 attachments[fi_name] = File.read(attach)
    mail(
            :to      => $site_details["email_to"],
												:bcc => ["udhayakumar.dhanabalan@gmail.com"],
            :from    => "scrape.coder@gmail.com",
            :subject => "SUMITOMO DAILY DATA"
    ) do |format|
format.html
end
  end				
					
end

class SumitomoDatatBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/sumitomo_data_builder_agent.log", 'weekly')
        #~ $logger.level = Logger::DEBUG
        $logger.formatter = Logger::Formatter.new
    end
    
    def establish_db_connection
        # connect to the MySQL server
        get_db_connection(@options[:env])
    end
    
		def start_processing
										begin
																		if $db_connection_established
																								Headless.ly do		
																														SumitomoData.delete_all
																														
																														#~ browser =  Watir::Browser.new :firefox, :profile => 'default'
																														browser = Watir::Browser.new:firefox, :profile => @profile
																														browser.goto "http://nationaltireonline.com/Login.aspx"
																														browser.text_field(:id, 'ctl00_Login_UserName').set($site_details["sumitomo_user_name"])
																													 browser.text_field(:id, 'ctl00_Login_Password').set($site_details["sumitomo_password"])
																														browser.button(:id=>'ctl00_Login_btnLogin').click
																													
																														sleep 5
																														browser.select_list(:id => 'ctl00_Login_ddlShipTos').option(:value,"20659124").select
																														browser.button(:id=>'ctl00_Login_btnSwitchShipTo').click
																															browser.goto "http://nationaltireonline.com/TireResults.aspx?searchtype=tire&sts=&sts2=&partno=SU*&onhand=True&pricing=DEALER&width=&ratio=&diameter=&brands="
																														#~ browser.text_field(:id, 'ctl00_LoggedInMainPanel_txtPartNumber').set("SU*")
																														#~ browser.button(:id=>'ctl00_LoggedInMainPanel_btnSearch3').click
																														#~ sleep 10
																														doc = Nokogiri::HTML.parse(browser.html)
																														temp_1 = doc.css("table#tableall tbody tr.promotedItem2")
																																temp_1.each do |t_1|
																																				inventory_number =""
																																		quantity =""
																																		quantity_updated_type = "Unshipped"
																																		seller_cost = ""
																																		dc_quantity = ""
																																		$logger.info  quantity= t_1.previous_element.css("td")[1].text.strip() if !t_1.previous_element.css("td")[1].nil? && t_1.css("td")[1]
																																$logger.info  inventory_number = "A+1:#{t_1.css("td")[2].text.strip()}:D" if !t_1.css("td")[2].nil? && t_1.css("td")[2] 		
																																dc_quantity = "Long Beach=#{quantity}".strip() if quantity
																																		SumitomoData.create(:inventory_number=>inventory_number, :quantity=>quantity, :quantity_updated_type=>quantity_updated_type, :seller_cost => seller_cost, :dc_quantity => dc_quantity)
																														end
																														
																														temp_2 = doc.css("table#tableall tbody tr.oddRow2")
																																temp_2.each do |t_2|
																																				inventory_number =""
																																		quantity =""
																																		quantity_updated_type = "Unshipped"
																																		seller_cost = ""
																																		dc_quantity = ""
																																		$logger.info  quantity= t_2.previous_element.css("td")[1].text.strip() if !t_2.previous_element.css("td")[1].nil? && t_2.css("td")[1]
																																$logger.info  inventory_number = "A+1:#{t_2.css("td")[2].text.strip()}:D"		 if !t_2.css("td")[2].nil? && t_2.css("td")[2]
																																dc_quantity = "Long Beach=#{quantity}".strip() if quantity
																																		SumitomoData.create(:inventory_number=>inventory_number, :quantity=>quantity, :quantity_updated_type=>quantity_updated_type, :seller_cost => seller_cost, :dc_quantity => dc_quantity)
																														end			

																										temp_3 = doc.css("table#tableall tbody tr.evenRow2")
																																temp_3.each do |t_3|
																																				inventory_number =""
																																		quantity =""
																																		quantity_updated_type = "Unshipped"
																																		seller_cost = ""
																																		dc_quantity = ""
																																		$logger.info  quantity= t_3.previous_element.css("td")[1].text.strip() if !t_3.previous_element.css("td")[1].nil? && t_3.css("td")[1]
																																$logger.info  inventory_number = "A+1:#{t_3.css("td")[2].text.strip()}:D"		 if !t_3.css("td")[2].nil? && t_3.css("td")[2]
																																dc_quantity = "Long Beach=#{quantity}".strip() if quantity
																																		SumitomoData.create(:inventory_number=>inventory_number, :quantity=>quantity, :quantity_updated_type=>quantity_updated_type, :seller_cost => seller_cost, :dc_quantity => dc_quantity)
																														end

																														#~ $logger.info  temp_file_path="#{Rails.root}/public/sumitomo_preprocessed_data/"
																														#~ $logger.info  latest_temp_file_path = Dir.glob(File.join(temp_file_path, '*.*')).max { |a,b| File.ctime(a) <=> File.ctime(b) }
																														#~ xlsx = Roo::Spreadsheet.open(latest_temp_file_path)
																																#~ xlsx.each_row_streaming do |row|
																																		#~ inventory_number =""
																																		#~ quantity =""
																																		#~ quantity_updated_type = "Unshipped"
																																		#~ seller_cost = ""
																																		#~ dc_quantity = ""
																																#~ if(!row[0].value.nil? && row[0].value != "" &&row[0].value.class.to_s != "Date" && row[0].value.strip() != "Site ID and Name")
																																		#$logger.info  row[0].value
																																		#~ $logger.info  inventory_number= row[5].value.gsub(/^SUMI-/,"A+1:")+":D" if !row[5].value.nil?
																																		#~ $logger.info  quantity= row[6].value.to_i.to_s if !row[6].value.nil?
																																		#~ $logger.info  dc_quantity = "Long Beach=" +  row[6].value.to_i.to_s if  row[6].value.to_i
																																		#~ SumitomoData.create(:inventory_number=>inventory_number, :quantity=>quantity, :quantity_updated_type=>quantity_updated_type, :seller_cost => seller_cost, :dc_quantity => dc_quantity)
																																#~ end
																														#~ end
																														browser.close
																														write_data_to_file					
																		
																end    
																end    
										rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
														sleep 10
														system("nohup bundle exec /usr/bin/ruby /var/www/apps/performanceplustire/current/agents/sumitomo/sumitomo_data_agent.rb -e production &")
										ensure
														$logger.close
														#~ #Our program will automatically will close the DB connection. But even making sure for the safety purpose.
														ActiveRecord::Base.clear_active_connections!
										end
				end
								
				def write_data_to_file
						@sumitomodata=SumitomoData.all
        Dir.mkdir("#{File.dirname(__FILE__)}/sumitomo_data") unless File.directory?("#{File.dirname(__FILE__)}/sumitomo_data")
								file_name = "sumitomo_#{Date.today.to_s}.txt"
        File.open("#{File.dirname(__FILE__)}/sumitomo_data/#{file_name}", 'w'){ |f|
								f.write "Inventory Number"+"\t"+"Quantity"+"\t"+"Quantity Update Type"+"\t"+"DC Quantity"
								f.write "\n"
								@sumitomodata.each do |sumitomodata|
										f.write sumitomodata.inventory_number+"\t"+sumitomodata.quantity+"\t"+sumitomodata.quantity_updated_type+"\t"+sumitomodata.dc_quantity
										f.write "\n"
								end
								}

										begin
												#~ Net::FTP.open($site_details["content_for_server_domain_name"], $site_details["content_for_server_ftp_login"], $site_details["content_for_server_ftp_password"]) do |ftp|
												#~ ftp.passive = true
												#~ files = ftp.chdir($site_details["ftp_path"])
												#~ $logger.info "sumitomo_data Files Started Transfer"
														#~ ftp.putbinaryfile("#{File.dirname(__FILE__)}/sumitomo_data/#{file_name}")
												#~ $logger.info "sumitomo_data Files ended Transfer"
												#~ files = ftp.list
														#~ $logger.info files
														#~ ftp.close
														#~ end
								
												send_email= SumitomoMailer.sumitomo_daily_data_email(file_name,"#{File.dirname(__FILE__)}/sumitomo_data/#{file_name}")
												send_email.deliver
								rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
								end


				end						
					
																										
end		

require 'rubygems'
require 'optparse'

options = {}
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: ruby sumitomo_agent.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the new sumitomo data processing' ) do |env|
    options[:env] = env
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( '-h', '--help', 'To get the list of available options' ) do
     opts
    exit
  end
end
optparse.parse!
		
@options = options		
require File.expand_path('../load_configurations', __FILE__)
sumitomo_agent = SumitomoDatatBuilderAgent.new(options)
sumitomo_agent.start_processing



