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

class NexentireonlineMailer < ActionMailer::Base
		
def nexentireonline_daily_data_email(fi_name,attach)
		puts "Sending email.."
		$logger.info "Sending email.."
		 attachments[fi_name] = File.read(attach)
    mail(
            :to      => $site_details["email_to"],
												:bcc => ["udhayakumar.dhanabalan@gmail.com"],
            :from    => "scrape.coder@gmail.com",
            :subject => "NEXTENTIREONINE DAILY DATA"
    ) do |format|
format.html
end
  end				
					
end

class NexentireonlineDatatBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/nexentireonline_data_builder_agent.log", 'weekly')
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
										NexentireonlineData.delete_all
												@browser = Watir::Browser.new:firefox, :profile => @profile
												#~ @browser =  Watir::Browser.new :firefox, :profile => 'default'
												@browser.goto "http://nexentireonline.com/login.aspx"
												@browser.text_field(:id, 'txtMid').set($site_details["nexentireonline_user_name"])
												@browser.text_field(:id, 'txtMpwd').set($site_details["nexentireonline_password"])
												@browser.button(:id=>'btLogin').click
												@browser.goto "http://nexentireonline.com/inventorylist.aspx"
												sleep 2
												@browser.button(:id=>'_ctl0_ContentPlaceHolder1_btnSearch').click
												
												
														@i = 2
														@num = 100

														while @i <= @num  do
																begin
																		doc = Nokogiri::HTML.parse(@browser.html)
																		#~ sleep 5
																		temp_1 = doc.css("table#_ctl0_ContentPlaceHolder1_gridList_WAREHOUSE tbody tr")
																		temp_1.each_with_index do |t_1,s|
																				material= "" ,material_desc= "" ,load= "" ,stock_ot= "" ,stock_at= "" ,stock_total= "" ,water_ot= "" ,water_at= "" ,water_total= "" ,arrival_ot= "" ,arrival_at= "" ,arrival_total= "" ,inventory_number= "" ,quantity= "" ,quantity_updated_type= "" ,seller_cost= "" ,dc_quantity = ""
																				if t_1.attr('class') != "GridViewPager"
																						if s >= 2
																								if (t_1.css("td")[0] && t_1.css("td")[0].text != "1" && t_1.css("td")[0].text != "...")
																										puts			material= t_1.css("td")[0].text.gsub("'","").strip()
																										load= t_1.css("td")[2].text.gsub("'","").strip()
																										stock_ot= t_1.css("td")[3].text.gsub("'","").strip()
																										inventory_number = "A+1:#{material}:D" if material
																										quantity = stock_ot if stock_ot
																										quantity_updated_type = "Unshipped"
																										seller_cost = ""
																										dc_quantity = "Long Beach=#{stock_ot}" if stock_ot
																												if !NexentireonlineData.exists?(:inventory_number => inventory_number)
																														NexentireonlineData.create(:inventory_number=>inventory_number, :quantity=>quantity, :quantity_updated_type=>quantity_updated_type, :seller_cost => seller_cost, :dc_quantity => dc_quantity)
																												end
																								end
																						end
																				end
																		end
																		 if (@i == 11)
																						@browser.tr(:class => "GridViewPager").link(:text => "...", :index=>0).click
																			elsif	(@i == 21 || @i == 31 || @i == 41 || @i == 51 || @i == 61 || @i == 71 || @i == 81 || @i == 91)
																				@browser.tr(:class => "GridViewPager").link(:text => "...", :index=>1).click
																		else
																				@browser.tr(:class => "GridViewPager").link(:text => @i.to_s).click
																		end
																		@i = @i+1
																		rescue
																		$logger.info "no more pages available"
																		puts "no more pages available"
																		@i = @i+1
																		end
												end																		
														@browser.close
														write_data_to_file					
						end
				end
										rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
														sleep 10
														#~ #system("nohup bundle exec /usr/bin/ruby /var/www/apps/performanceplustire/current/agents/nexentireonline/nexentireonline_data_agent.rb -e production &")
										ensure
														$logger.close
														#~ #Our program will automatically will close the DB connection. But even making sure for the safety purpose.
														ActiveRecord::Base.clear_active_connections!
										end
		end
								
				def write_data_to_file
						@nexentireonlinedata=NexentireonlineData.all
        Dir.mkdir("#{File.dirname(__FILE__)}/nexentireonline_data") unless File.directory?("#{File.dirname(__FILE__)}/nexentireonline_data")
								file_name = "nexentireonline_#{Date.today.to_s}.txt"
        File.open("#{File.dirname(__FILE__)}/nexentireonline_data/#{file_name}", 'w'){ |f|
								f.write "Inventory Number"+"\t"+"Quantity"+"\t"+"Quantity Update Type"+"\t"+"Seller Cost"+"\t"+"DC Quantity"
								f.write "\n"
								@nexentireonlinedata.each do |nexentireonlinedata|
										f.write nexentireonlinedata.inventory_number+"\t"+nexentireonlinedata.quantity+"\t"+nexentireonlinedata.quantity_updated_type+"\t"+nexentireonlinedata.seller_cost+"\t"+nexentireonlinedata.dc_quantity
										f.write "\n"
								end
								}
								send_email= NexentireonlineMailer.nexentireonline_daily_data_email(file_name,"#{File.dirname(__FILE__)}/nexentireonline_data/#{file_name}")
								send_email.deliver
				end						
					
																										
end		

require 'rubygems'
require 'optparse'

options = {}
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: ruby nexentireonline_data_agent.rb [options]"

  # Define the options, and what they do
  options[:action] = 'start'
  opts.on( '-a', '--action ACTION', 'It can be start, stop, restart' ) do |action|
    options[:action] = action
  end

  options[:env] = 'development'
  opts.on( '-e', '--env ENVIRONMENT', 'Run for nexentireonline data' ) do |env|
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
newprojects_agent = NexentireonlineDatatBuilderAgent.new(options)
newprojects_agent.start_processing
