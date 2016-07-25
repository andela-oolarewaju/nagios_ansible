require 'open3'
require_relative 'vars'

#Apache scenerio
When(/^I install Apache$/) do 
	cmd = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'apache_setup'"

	output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^it should be successful$/) do 
	expect(@status.success?).to eq(true)
end

And(/^Apache should be running$/) do
	command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS} 'sudo service apache2 status'"
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to match("apache2 is running")
end

And(/^it should be accepting connections on Port ([^"]*)$/) do |port|
  command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS} 'curl -f http://localhost:#{port}'"
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
end


#SQL Scenario
When(/^I install MySQL$/) do
	command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'sql_setup'"
  
  output, error, @status = Open3.capture3 "#{command}"
end

And(/^MySQL should be running$/) do 
	command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS} '/etc/init.d/mysql status'"
	output, error, status = Open3.capture3 "#{command}"

	expect(status.success?).to eq(true)
	expect(output).to match("mysql start/running")
end

#PHP Scenario
When(/^I install PHP$/) do
	command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'php_setup'"
  
  output, error, @status = Open3.capture3 "#{command}"
end

#Nagios Scenario
When(/^I create a group$/) do
	command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'group'"

	output, error, @status = Open3.capture3 "#{command}"
end

And(/^I add a user to a group$/) do 
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'user_group'"
  
  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I install nagios dependencies$/) do
	command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'dependencies'"
  
  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I download  and extract nagios source code$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'source_code'"

  output, error, @status = Open3.capture3 "#{command}"
end 

When(/^I configure nagios$/) do 
	command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'configure'"

  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I compile nagios$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'compile'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

When(/^I add web server to group$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'web_server'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

When(/^I download and extract nagios plugin file$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'nagios_plugin'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

When(/^I configure nagios plugins$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'configure_nagios_plugins'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

When(/^I compile and install nagios plugins$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'compile_nagios_plugins'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 


When(/^I download and extract nrpe file$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'nrpe'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

When(/^I configure nrpe$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'configure_nrpe'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

When(/^I compile and install nrpe$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'compile_nrpe'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

When(/^I add server ip address$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'server_ip_address'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

And(/^I restart xinetd service$/) do
  command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS} 'sudo service xinetd status'"
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to match("xinetd start/running,")
end

When(/^I set config directory$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'set_config'"

  output, error, @status = Open3.capture3 "#{command}"
end 

Then(/^config directory should be set$/) do
	command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS} 'cat /usr/local/nagios/etc/nagios.cfg | grep cfg_dir=/usr/local/nagios/etc/servers'"
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to match("cfg_dir=/usr/local/nagios/etc/servers")
end

When(/^I copy host config file$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'copy_host_config_file'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

When(/^I add email to contacts config$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'set_email'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end

And(/^email should exist$/) do
	command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS} 'cat /usr/local/nagios/etc/objects/contacts.cfg | grep email'"
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to match("email #{CONTACTEMAIL}")
end

When(/^I add check_nrpe command$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'add_check_nrpe'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I add check_ping command$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'check_ping'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I add check_http command$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'check_http'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I add check_memory command$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'check_memory'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I add check_netio command$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'check_netio'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end

When(/^I create nagios user and password$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'password_setup'"	
  
  output, error, @status = Open3.capture3 "#{command}"
end 

Then(/^it should exist in password file$/) do
  command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS} 'cat /usr/local/nagios/etc/htpasswd.users | grep nagiosadmin'" 

  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to match("nagiosadmin")
end

When(/^I finish setting up nagios$/) do
  command = "ansible-playbook -i inventory.ini -u ubuntu playbook.main.yml --tags 'password_setup'"	
  output, error, @status = Open3.capture3 "#{command}"
end

Then(/^Http metrics should exist$/) do
  command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS}" && "curl -u nagiosadmin:#{NAGIOSPASSWORD} http://#{NAGIOSIP}/nagios/cgi-bin/status.cgi?host=#{HOST} | grep \"valign='center'>\" | grep \"HTTP\"" 
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to include("HTTP")
end

And(/^Memory usage metrics should exist$/) do
  command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS}" && "curl -u nagiosadmin:#{NAGIOSPASSWORD} http://#{NAGIOSIP}/nagios/cgi-bin/status.cgi?host=#{HOST} | grep \"valign='center'>\" | grep \"Memory:\"" 
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to include("Memory:")
end

And(/^Netio metric should exist$/) do
  command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS}" && "curl -u nagiosadmin:#{NAGIOSPASSWORD} http://#{NAGIOSIP}/nagios/cgi-bin/status.cgi?host=#{HOST} | grep \"valign='center'>\" | grep \"NETIO\"" 
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to include("NETIO")
end

And(/^PING metric should exist$/) do
  command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS}" && "curl -u nagiosadmin:#{NAGIOSPASSWORD} http://#{NAGIOSIP}/nagios/cgi-bin/status.cgi?host=#{HOST} | grep \"valign='center'>\" | grep \"PING\"" 
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to include("PING")
end

And(/^SSH metric should exist$/) do
  command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS}" && "curl -u nagiosadmin:#{NAGIOSPASSWORD} http://#{NAGIOSIP}/nagios/cgi-bin/status.cgi?host=#{HOST} | grep \"valign='center'>\" | grep \"SSH\"" 
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to include("SSH")
end

And(/^Current Load metric should exist$/) do
  command = "ssh -i '#{PATHTOPRIVATEKEY}' #{AWSPUBDNS}" && "curl -u nagiosadmin:#{NAGIOSPASSWORD} http://#{NAGIOSIP}/nagios/cgi-bin/status.cgi?host=#{HOST} | grep \"valign='center'>\" | grep \"load\"" 
  output, error, status = Open3.capture3 "#{command}"

  expect(status.success?).to eq(true)
  expect(output).to include("load")
end



