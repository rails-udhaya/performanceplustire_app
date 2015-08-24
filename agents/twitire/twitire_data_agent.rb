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

class TwitireMailer < ActionMailer::Base
		
def twitire_daily_data_email(fi_name,attach)
		puts "Sending email.."
		$logger.info "Sending email.."
		 attachments[fi_name] = File.read(attach)
    mail(
           
            :to      => $site_details["email_to"],
												:bcc => ["udhayakumar.dhanabalan@gmail.com"],
            :from    => "scrape.coder@gmail.com",
            :subject => "TWITIRE DAILY DATA"
    ) do |format|
format.html
end
  end				
					
end

class TwitireDatatBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/twitire_data_builder_agent.log", 'weekly')
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
																								TwitireData.delete_all
																								patt = TwitireList.where(:is_enabled => true)

																								browser = Watir::Browser.new:firefox, :profile => @profile
																								browser.goto "http://twitire.tireweb.com/"
																								browser.text_field(:id, 'UserName').set($site_details["twitire_user_name"])
																								browser.text_field(:id, 'PASSWORD').set($site_details["twitire_password"])
																								browser.button(:id => 'submit').click

																								patt.each do |p|
																										$logger.info "Processing...... #{p.category}, #{p.image_url}"
																											image_url = p.image_url
																											hexa_pattern  = p.hexa_pattern
																														browser.goto "http://twitire.tireweb.com/Retail/PriceListNew.asp"
																														browser.font(:text, "All").click
																														browser.image(:src => image_url).click
																														sleep 5
																														doc = Nokogiri::HTML.parse(browser.html)
																														temp_1 = doc.css("table#ATable tr")
																														temp_1.each_with_index do |t_1,s|
																																		if s > 1
																																				inventory_number	= ""
																																				quantity		= ""
																																				dc_quantity		= ""
																																				seller_cost		= ""
																																				manufacturer	= ""
																																				mpn		= ""
																																				attribute1_name 	= "Manufacturer"
																																				attribute1_value		= "" 
																																				attribute2_name	= "TreadX Description"
																																				attribute2_value	= ""
																																				classification	= "Tire"
																																				dc_code		= "TWI-MI"
																																				attribute3_name	= "Group"
																																				attribute3_value	= "TIRE"
																																				attribute4_name	= "eBay Store Category"
																																				attribute4_value	= "Tires"
																																				quantity_update	= "Unshipped"
																																				labels_for	= "ebay,tire"
																																						if (t_1.css("td") && t_1.css("td")[0] && t_1.css("td")[0].css("table"))
																																								temp_9 = t_1.css("td")[0].css("table td")
																																								temp_9.each do |t_9|
																																										t_9.remove
																																								end
																																								t_1.css("td")[0].css("table").remove if t_1.css("td")[0].css("table")
																																						end

																																					puts inventory_number = t_1.css("td")[1].text.gsub("'","''").split(/^#{hexa_pattern}/).join.strip()+":D" if t_1.css("td") && !t_1.css("td")[1].nil?
																																					if inventory_number != ""
																																							quantity = t_1.css("td")[5].text.gsub("+","").gsub("'","''").strip() if t_1.css("td") && !t_1.css("td")[5].nil?
																																							dc_quantity = "TWI-MI="+t_1.css("td")[5].text.gsub("+","").gsub("'","''").strip() if t_1.css("td") && !t_1.css("td")[5].nil?
																																							seller_cost = t_1.css("td")[4].text.gsub("$","").gsub("'","''").strip() if t_1.css("td") && !t_1.css("td")[4].nil?
																																						manufacturer = p.category
																																						mpn= t_1.css("td")[1].text.gsub("'","''").split(/^#{hexa_pattern}/).join.strip() if t_1.css("td") && !t_1.css("td")[1].nil?
																																						attribute1_value		= p.category
																																						attribute2_value		= t_1.css("td")[3].text.gsub("'","''").strip() if t_1.css("td") && !t_1.css("td")[3].nil?
																																						#~ puts inventory_number	
																																						#~ puts quantity	
																																						#~ puts dc_quantity	
																																						#~ puts seller_cost	
																																						#~ puts manufacturer
																																						#~ puts mpn	
																																						#~ puts attribute1_name
																																						#~ puts attribute1_value	
																																						#~ puts attribute2_name
																																						#~ puts attribute2_value
																																						#~ puts classification
																																						#~ puts dc_code	
																																						#~ puts attribute3_name
																																						#~ puts attribute3_value
																																						#~ puts attribute4_name
																																						#~ puts attribute4_value
																																						#~ puts quantity_update
																																						TwitireData.create(:inventory_number=>inventory_number, :quantity=>quantity, :dc_quantity=>dc_quantity, :seller_cost => seller_cost, :manufacturer => manufacturer, :mpn => mpn, :attribute1_name=> attribute1_name, :attribute1_value => attribute1_value, :attribute2_name => attribute2_name, :attribute2_value => attribute2_value, :classification => classification, :dc_code => dc_code, :attribute3_name => attribute3_name, :attribute3_value => attribute3_value, :attribute4_name => attribute4_name, :attribute4_value => attribute4_value, :quantity_update => quantity_update, :labels_for=> labels_for)
																																		   end
																																		end
																												end					
																										
																								end
																										browser.close
																										write_data_to_file																				
																						
																						end    
																end    
										rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
														puts "Error"
														browser.close
														sleep 10
														system("nohup bundle exec /usr/bin/ruby /var/www/apps/performanceplustire/current/agents/twitire/twitire_data_agent.rb -e production &")
										ensure
														$logger.close
														#Our program will automatically will close the DB connection. But even making sure for the safety purpose.
														ActiveRecord::Base.clear_active_connections!
										end
				end
								
				def write_data_to_file
						@twitiredata=TwitireData.all
        Dir.mkdir("#{File.dirname(__FILE__)}/twitire_data") unless File.directory?("#{File.dirname(__FILE__)}/twitire_data")
								file_name = "twitire_#{Date.today.to_s}.txt"
        File.open("#{File.dirname(__FILE__)}/twitire_data/#{file_name}", 'w'){ |f|
								f.write "Inventory Number"+"\t"+"Quantity"+"\t"+"DC Quantity"+"\t"+"Seller Cost"+"\t"+"Manufacturer"+"\t"+"MPN"+"\t"+"Attribute1Name"+"\t"+"Attribute1Value"+"\t"+"Attribute2Name"+"\t"+"Attribute2Value"+"\t"+"Classification"+"\t"+"DC Code"+"\t"+"Attribute3Name"+"\t"+"Attribute3Value"+"\t"+"Attribute4Name"+"\t"+"Attribute4Value"+"\t"+"Quantity Update Type"+"\t"+"Labels"
								f.write "\n"
								@twitiredata.each do |twitiredata|
										f.write twitiredata.inventory_number+"\t"+twitiredata.quantity+"\t"+twitiredata.dc_quantity+"\t"+twitiredata.seller_cost+"\t"+twitiredata.manufacturer+"\t"+twitiredata.mpn+"\t"+twitiredata.attribute1_name+"\t"+twitiredata.attribute1_value+"\t"+twitiredata.attribute2_name+"\t"+twitiredata.attribute2_value+"\t"+twitiredata.classification+"\t"+twitiredata.dc_code+"\t"+twitiredata.attribute3_name+"\t"+twitiredata.attribute3_value+"\t"+twitiredata.attribute4_name+"\t"+twitiredata.attribute4_value+"\t"+twitiredata.quantity_update+"\t"+twitiredata.labels_for
										f.write "\n"
								end
								}
								send_email= TwitireMailer.twitire_daily_data_email(file_name,"#{File.dirname(__FILE__)}/twitire_data/#{file_name}")
								send_email.deliver
				end						
					
																										
end		

require 'rubygems'
require 'optparse'

options = {}
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: ruby twitire_data_agent.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the new twitire projects agent for building the projects' ) do |env|
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
newprojects_agent = TwitireDatatBuilderAgent.new(options)
newprojects_agent.start_processing

