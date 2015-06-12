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
  :password             => "odesk2015",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
ActionMailer::Base.view_paths= File.dirname(__FILE__)

class AtdonlineMailer < ActionMailer::Base
		
def atdonline_daily_data_email(fi_name,attach)
		puts "Sending email.."
		$logger.info "Sending email.."
		 attachments[fi_name] = File.read(attach)
    mail(
            :to      => "kbrown@performanceplustire.com",
            #~ :to      => "udhayakumar.dhanabalan@gmail.com",
												:bcc => ["udhayakumar.dhanabalan@gmail.com"],
            :from    => "scrape.coder@gmail.com",
            :subject => "ATDONLINE DAILY DATA"
    ) do |format|
format.html
end
  end				
					
end

class AtdonlineDatatBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/atdonline_data_builder_agent.log", 'weekly')
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
																				#~ Headless.ly do		
																				
																				AtdonlineData.delete_all
																				browser = Watir::Browser.new

																					browser.goto "http://www.atdonline.com/atdonline.asp"
																					browser.text_field(:id, 'f_userid').set("306036890")
																					browser.text_field(:id, 'f_password').set("3489pte")
																					browser.input(:value, 'LOGIN TO ATDONLINE').click
																					sleep 5
																					browser.goto "http://www.atdonline.com/opt-in.php"
																					
																				lis = AtdonlineList.where(:is_enabled=>true) 
																				lis.each do |l|
																						browser.goto "http://www.atdonline.com/search/refine?preferredBrands=N&Ntk=Search.atdonline_global&availabilityOptionSelected=national&N=10929&NoResultsFromFiltersMessaging=N&Ntt=**#{l['brand_name']}**&categoryTitle=Passenger+%26+Light+Truck"
																				doc = Nokogiri::HTML.parse(browser.html)
																				temp_1=doc.css("table tbody tr")
																				temp_1.each do |t_1|
																				size="NA"
																				description="NA"
																				supplier="NA"
																				load_speed="NA"
																				mileage_warranty="NA"
																				sidewall="NA"
																				local_dc="NA"
																				local="NA"
																				cost = "NA"

		puts size=t_1.css("td.product").to_s.split("</strong>").first.split("<strong>").last.gsub("'","").strip() if !t_1.css("td.product").nil? && !t_1.css("td.product").to_s.split("</strong>").first.nil?
		if size != "NA"
		puts description=t_1.css("td.product").to_s.split("</strong>")[1].split("<br>")[1].split("<br>").first.gsub("'","").strip() if !t_1.css("td.product").nil? && !t_1.css("td.product").to_s.split("</strong>")[1].nil?
			if t_1.css("td.specs").at('span:contains("Supplier #")')
							puts supplier = t_1.at('span:contains("Supplier #")').parent.next_element.text.gsub("'","''").strip()
					end
					
						if t_1.css("td.specs").at('span:contains("Load/Speed")')
							puts load_speed = t_1.at('span:contains("Load/Speed")').parent.next_element.text.gsub("'","''").strip()
					end
					
						if t_1.css("td.specs").at('span:contains("Mileage Warranty")')
							puts mileage_warranty = t_1.at('span:contains("Mileage Warranty")').parent.next_element.text.gsub("'","''").strip()
					end
					
						if t_1.css("td.specs").at('span:contains("Sidewall")')
							puts sidewall = t_1.at('span:contains("Sidewall")').parent.next_element.text.gsub("'","''").strip()
					end					
					
						if t_1.css("td.inventory").at('span:contains("Local DC")')
							puts local_dc = t_1.at('span:contains("Local DC")').parent.next_element.text.gsub("'","''").strip()
					end
					
						if t_1.css("td.inventory").at('span:contains("Local+")')
							puts local = t_1.at('span:contains("Local+")').parent.next_element.text.gsub("'","''").strip()
					end
					
							puts cost = t_1.css("span.smaller.product-list-cost-panel").text.gsub("Cost","").gsub("'","''").strip()
					
						
						begin
						AtdonlineData.create(:size=>size,:description=>description,:supplier=>supplier,:load_speed=>load_speed,:mileage_warranty=>mileage_warranty,:sidewall=>sidewall,:local_dc=>local_dc,:local=>local,:cost=>cost)
						rescue
						puts "Error in Inserting record"
						$logger.info "Error in Inserting record"
						end
		end
																				end
																				end
																				
																				
																				browser.close
																				write_data_to_file																				
																		
																		end    
				#~ end    
										rescue Exception => e
														puts "Error Occured - #{e.message}"
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
										ensure
														$logger.close
														#~ #Our program will automatically will close the DB connection. But even making sure for the safety purpose.
														ActiveRecord::Base.clear_active_connections!
										end
				end
								
				def write_data_to_file
						@atdonlinedata=AtdonlineData.all
        Dir.mkdir("#{File.dirname(__FILE__)}/atdonline_data") unless File.directory?("#{File.dirname(__FILE__)}/atdonline_data")
								file_name = "atdonline_#{Date.today.to_s}.txt"
        File.open("#{File.dirname(__FILE__)}/atdonline_data/#{file_name}", 'w'){ |f|
									
								f.write "Size"+"\t"+"Description"+"\t"+"Supplier"+"\t"+"Load Speed"+"\t"+"Mileage Warranty"+"\t"+"Sidewall"+"\t"+"Local DC"+"\t"+"Local"+"\t"+"Cost"
								f.write "\n"
								@atdonlinedata.each do |atdonlinedata|
										f.write atdonlinedata.size+"\t"+atdonlinedata.description+"\t"+atdonlinedata.supplier+"\t"+atdonlinedata.load_speed+"\t"+atdonlinedata.mileage_warranty+"\t"+atdonlinedata.sidewall+"\t"+atdonlinedata.local_dc+"\t"+atdonlinedata.local+"\t"+atdonlinedata.cost
										f.write "\n"
								end
								}
								send_email= AtdonlineMailer.atdonline_daily_data_email(file_name,"#{File.dirname(__FILE__)}/atdonline_data/#{file_name}")
								send_email.deliver
				end						
					
																										
end		

require 'rubygems'
require 'optparse'

options = {}
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: ruby newprojects_agent.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run the new atdonlinedata data' ) do |env|
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
newprojects_agent = AtdonlineDatatBuilderAgent.new(options)
newprojects_agent.start_processing
