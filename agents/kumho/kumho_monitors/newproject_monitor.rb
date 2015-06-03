require "rubygems"
require 'logger' 


						Dir.mkdir("#{File.dirname(__FILE__)}/logs") unless File.directory?("#{File.dirname(__FILE__)}/logs")
						$logger = Logger.new("#{File.dirname(__FILE__)}/logs/newprojects_monitor.log", 'weekly')
						#~ $logger.level = Logger::DEBUG
						$logger.formatter = Logger::Formatter.new

#~ while true do
pid_status_english = system("ps -aux | grep newprojects_agent.rb | grep -vq grep")
				if pid_status_english
						$logger.info ("nothing to do....")
				else
						$logger.info ("Process started....")
						system("nohup bundle exec /usr/bin/ruby ../newprojects_agent.rb &")
				end
#~ sleep 300
#~ end