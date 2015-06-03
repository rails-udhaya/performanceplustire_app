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

class KumhoMailer < ActionMailer::Base
		
def kumho_daily_data_email(fi_name,attach)
		puts "Sending email.."
		$logger.info "Sending email.."
		 attachments[fi_name] = File.read(attach)
    mail(
            :to      => "kbrown@performanceplustire.com",
												:bcc => ["udhayakumar.dhanabalan@gmail.com"],
            :from    => "scrape.coder@gmail.com",
            :subject => "KUMHO DAILY DATA"
    ) do |format|
format.html
end
  end				
					
end

class KumhoDatatBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/kumho_data_builder_agent.log", 'weekly')
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
																		KumhotireepicData.delete_all
																		patt = KumhotireepicPattern.where(:is_enabled => true)
																		browser = Watir::Browser.new:firefox, :profile => @profile
																		browser.goto "http://www.kumhotireepic.com/"
																		browser.text_field(:name, 'txtId').set("1090614")
																		browser.text_field(:name, 'txtPass').set("3910pplus")
																		browser.a(:index=>0).click
																		browser.goto "http://www.kumhotireepic.com/epic_work_source/Product/Stocklnquiry010.asp"
																		browser.checkbox(:name => 'realTimeStock').clear
																		patt.each do |p|
																				$logger.info "Processing...... #{p.pattern}"
																						browser.select_list(:id => 'pattern').option(:text, p.pattern).select
																						browser.checkbox(:name => 'realTimeStock').clear
																						browser.img(:alt => 'Browse').click
																						sleep 2
																						doc = Nokogiri::HTML.parse(browser.html)
																						temp_1 = doc.css("table.subpagenaviTable")
																						cnt = (temp_1.at('td:contains("Result:")').text .gsub("Result:","").to_f/15).ceil
																						$logger.info "ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss #{cnt}"
																						@i = 1
																								while @i <= cnt  do 
																										puts @i
																										if @i != 1
																														browser.a(:text => @i.to_s).fire_event("click")																												
																										end
																										doc_1 = Nokogiri::HTML.parse(browser.html)
																										temp_2=doc_1.css("table#dataTable tr")
																										temp_2.each do |t_2|
																												inventory_number =""
																												quantity =""
																												quantity_updated_type = "Unshipped"
																												seller_cost = ""
																												dc_quantity = ""
																												
																												puts inventory_number = "A+1:#{t_2.css("td")[1].text.split(" ").first}:D"
																													
																														if(t_2.css("td")[8].text.gsub("\n","").strip() == "Out of Stock")
																														quantity = "0"
																												elsif(t_2.css("td")[8].text.gsub("\n","").strip() == "49+")
																														quantity = "40"
																												else
																														quantity =t_2.css("td")[8].text.gsub("\n","").gsub("+","").strip()
																												end
																												
																												dc_quantity = "Long Beach=#{quantity}".strip()
																												
																												#~ puts inventory_number
																												#~ puts quantity
																												#~ puts quantity_updated_type
																												#~ puts seller_cost
																												#~ puts dc_quantity
																												KumhotireepicData.create(:inventory_number=>inventory_number, :quantity=>quantity, :quantity_updated_type=>quantity_updated_type, :seller_cost => seller_cost, :dc_quantity => dc_quantity)
																										end
																										@i = @i+1
																								end
																		end
																		
																				write_data_to_file																				
																		
																		end    
										rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
										ensure
														$logger.close
														#~ #Our program will automatically will close the DB connection. But even making sure for the safety purpose.
														browser.close
														ActiveRecord::Base.clear_active_connections!
										end
				end
								
				def write_data_to_file
						@kumhotireepicdata=KumhotireepicData.all
        Dir.mkdir("#{File.dirname(__FILE__)}/kumho_data") unless File.directory?("#{File.dirname(__FILE__)}/kumho_data")
								file_name = "kumho_#{Date.today.to_s}.txt"
        File.open("#{File.dirname(__FILE__)}/kumho_data/#{file_name}", 'w'){ |f|
								f.write "Inverntory Number"+'        '+"Quantity"+'        '+"Quantity Updated Type"+'        '+"Seller Cost"+'        '+"DC Quantity"
								f.write "\n"
								@kumhotireepicdata.each do |kumhotireepicdata|
										f.write kumhotireepicdata.inventory_number+'        '+kumhotireepicdata.quantity+'        '+kumhotireepicdata.quantity_updated_type+'        '+kumhotireepicdata.seller_cost+'        '+kumhotireepicdata.dc_quantity
										f.write "\n"
								end
								}
								send_email= KumhoMailer.kumho_daily_data_email(file_name,"#{File.dirname(__FILE__)}/kumho_data/#{file_name}")
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
  opts.on( '-e', '--env ENVIRONMENT', 'Run the new kickstart projects agent for building the projects' ) do |env|
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
newprojects_agent = KumhoDatatBuilderAgent.new(options)
newprojects_agent.start_processing
