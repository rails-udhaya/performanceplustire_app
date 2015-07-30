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

class ContilinkMailer < ActionMailer::Base
		
def contilink_daily_data_email(fi_name,attach)
		puts "Sending email.."
		$logger.info "Sending email.."
		 attachments[fi_name] = File.read(attach)
    mail(
            :to      => $site_details["email_to"],
												:bcc => ["udhayakumar.dhanabalan@gmail.com"],
            :from    => "scrape.coder@gmail.com",
            :subject => "CONTILINK DAILY DATA"
    ) do |format|
format.html
end
  end				
					
end

class ContilinkDatatBuilderAgent
    attr_accessor :options, :errors
    
    def initialize(options)
        @options = options  
								 @options
								create_log_file
        establish_db_connection
    end
    
    
    def create_log_file
        Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
        $logger = Logger.new("#{File.dirname(__FILE__)}/logs/contilink_data_builder_agent.log", 'weekly')
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
																		ContilinkData.delete_all
																		
																		@browser = Watir::Browser.new:firefox, :profile => @profile
																		#~ @browser =  Watir::Browser.new :firefox, :profile => 'default'
																		@browser.goto "https://www.contilink.com/"
																		@browser.text_field(:id, 'username').set($site_details["contilink_user_name"])
																		@browser.text_field(:id, 'password').set($site_details["contilink_password"])
																		@browser.button(:class=>'btn-submit btn btn-small').click
																		
																		first_set_data_collection
																		second_set_data_collection
																		second_set_data_collection_recheck
																		ContilinkData.where(whs: nil).delete_all
																		@browser.close
																				write_data_to_file																				
																		end    
																end    
										rescue Exception => e
														$logger.error "Error Occured - #{e.message}"
														$logger.error e.backtrace
														sleep 10
														system("nohup bundle exec /usr/bin/ruby /var/www/apps/performanceplustire/current/agents/contilink/contilink_data_agent.rb -e production &")
										ensure
														$logger.close
														#~ #Our program will automatically will close the DB connection. But even making sure for the safety purpose.
														ActiveRecord::Base.clear_active_connections!
										end
				end
					

		def first_set_data_collection
										begin
										patt = ContilinkList.where(:is_enabled => true)
										patt.each do |p|
														$logger.info "Processing...... #{p.product_line_code}"
														brand = p["brand_code"]
														category = p["category_code"]
														product_line = p["product_line_code"]
																		url = "https://www.contilink.com/jsp/ordering/order/tireSearch.do?tireSize=&brands=#{brand}&ml=#{product_line}&type=#{category}"
																		puts url 
																		$logger.info url 
																		@browser.goto url
																		doc = Nokogiri::HTML.parse(@browser.html)
																		temp_1 = doc.css("table tbody tr")
																temp_1.each do |t_1|
																		reference_id= ""
																		$logger.info reference_id = t_1.css("td")[0].to_s.split("value=").last.split(" ").first.gsub('"','').strip()
																					if !ContilinkData.exists?(:reference_id => reference_id)
																								ContilinkData.create(:reference_id=>reference_id)
																 				end
																end
								end
												rescue
														puts "Error in first set process"
														$logger.info "Error in first set process"
												end																				
				end		
										
		def second_set_data_collection
				  begin
						if ContilinkData.count > 0
								puts "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuu #{ContilinkData.count}"
														ContilinkData.find_in_batches(batch_size: 80) do |group|
																begin
																reference = group.collect(&:reference_id).join(",")
															puts url_3="https://www.contilink.com/jsp/ordering/ajax/checkAvailability.do?articleAvail=#{reference}"	
															$logger.info url_3
															@browser.goto url_3
															sleep 10
												doc_3 = Nokogiri::HTML.parse(@browser.html)
											temp_3 =   JSON.parse(doc_3.text)
											temp_3.each do |t_3|
												article=""
												whs= "" 
												des_qty= "" 
												on_hand_avail_qty= "" 
												in_tran_available= "" 
												price_fet= "" 
												unit_fet= "" 
												weight= "" 
												article_description= "" 
												quantity_updated_type = "Unshipped"
												seller_cost = ""
												dc_quantity = ""

											if ((t_3["whs"].downcase == "ca" || t_3["whs"].downcase == "california"))
													whs = t_3["whs"] 
													article = "A+1:#{t_3["article"]}:D" if t_3["article"]
													article_reference = t_3["article"]
													on_hand_avail_qty = t_3["available_qty"] 
													in_tran_available = t_3["in_trans_qty"] 
													price_fet = t_3["price_fet"] 
													unit_fet = t_3["unit_fet"] 
													dc_quantity = "Long Beach=#{on_hand_avail_qty}".strip()
													contilink_d=ContilinkData.where(reference_id: article_reference).first
													if !contilink_d.nil?
													contilink_d.update_attributes(:whs => whs, :article => article, :on_hand_avail_qty => on_hand_avail_qty, :in_tran_available => in_tran_available, :price_fet => price_fet, :unit_fet=> unit_fet, :quantity_updated_type => quantity_updated_type, :seller_cost => seller_cost, :dc_quantity => dc_quantity)
												end
													#~ sleep 5
									  end
								 end	
											rescue
													puts  "error in 2 a inside"
												$logger.info  "error in 2 a insied"
											end
										end
						end
						rescue
							   puts  "error in 2 a "
										$logger.info  "error in 2 a"
						end
  end				
							
		def second_set_data_collection_recheck
		  begin
						if ContilinkData.count > 0
								ContilinkData.where(whs: nil).each do |contilink_data|
									begin	
										reference_id = contilink_data["reference_id"]
										puts url_2="https://www.contilink.com/jsp/ordering/ajax/checkAvailability.do?articleAvail=#{reference_id}"
										$logger.info url_2 
										@browser.goto url_2
										doc_2 = Nokogiri::HTML.parse(@browser.html)
									temp_2 =   JSON.parse(doc_2.text)
									temp_2.each do |t_2|
												article=""
												whs= "" 
												des_qty= "" 
												on_hand_avail_qty= "" 
												in_tran_available= "" 
												price_fet= "" 
												unit_fet= "" 
												weight= "" 
												article_description= ""
												quantity_updated_type = "Unshipped"
												seller_cost = ""
												dc_quantity = ""


											if ((t_2["whs"].downcase == "ca" || t_2["whs"].downcase == "california") && (t_2["article"] == reference_id))
													whs = t_2["whs"] 
													article = "A+1:#{t_2["article"]}:D" if t_2["article"]
													on_hand_avail_qty = t_2["available_qty"] 
													in_tran_available = t_2["in_trans_qty"] 
													price_fet = t_2["price_fet"] 
													unit_fet = t_2["unit_fet"] 
													dc_quantity = "Long Beach=#{on_hand_avail_qty}".strip()
													contilink_data.update_attributes(:whs => whs, :article => article, :on_hand_avail_qty => on_hand_avail_qty, :in_tran_available => in_tran_available, :price_fet => price_fet, :unit_fet=> unit_fet, :quantity_updated_type => quantity_updated_type, :seller_cost => seller_cost, :dc_quantity => dc_quantity)
													#~ sleep 5
									  end
								 end
									rescue
										puts  "error in 2 a fine tune"
										$logger.info  "error in 2 a fine tune"
									end
							end		
						end
				rescue
								puts "Error in second set process fine tune"
				end
		end								
							
								
				def write_data_to_file
						@contilinkdata=ContilinkData.all
        Dir.mkdir("#{File.dirname(__FILE__)}/contilink_data") unless File.directory?("#{File.dirname(__FILE__)}/contilink_data")
								file_name = "contilink_#{Date.today.to_s}.txt"
        File.open("#{File.dirname(__FILE__)}/contilink_data/#{file_name}", 'w'){ |f|
								f.write "Inventory Number"+"\t"+"Quantity"+"\t"+"Quantity Update Type"+"\t"+"Seller Cost"+"\t"+"DC Quantity"
								f.write "\n"
								@contilinkdata.each do |contilinkdata|
										begin
										f.write contilinkdata.article+"\t"+contilinkdata.on_hand_avail_qty+"\t"+contilinkdata.quantity_updated_type+"\t"+contilinkdata.seller_cost+"\t"+contilinkdata.dc_quantity
										f.write "\n"
										rescue
										end
								end
								}
								send_email= ContilinkMailer.contilink_daily_data_email(file_name,"#{File.dirname(__FILE__)}/contilink_data/#{file_name}")
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
newprojects_agent = ContilinkDatatBuilderAgent.new(options)
newprojects_agent.start_processing
