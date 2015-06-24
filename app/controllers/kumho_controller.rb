class KumhoController < ApplicationController
		
		def kumho_data_process
						pid_status_english = system("ps -aux | grep kumho_data_agent.rb | grep -vq grep")
										if pid_status_english
												@status = "Process already running so nothing to do please wait"
										else
												#~ puts "sssssssssssssssssssssssssssssssssssssssssssssssssssssss"
												@status = "Process Newly getting started please wait for some times to get result"
												#~ puts "uuuuuuuuuuuuuuuuuuuu"
												#~ system("bundle exec ruby C:/Users/Udhayakumar/Desktop/Projects/performanceplustire_app/agents/kumho/kumho_data_agent.rb")
												#~ puts "kkkkkkkkkkkkkkkkkk"
												system("nohup bundle exec /usr/bin/ruby /var/www/apps/performanceplustire/current/agents/kumho/kumho_data_agent.rb -e production &")
										end		
		
		end
		
		
end
