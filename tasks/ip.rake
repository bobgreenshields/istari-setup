require 'tty-prompt'
require 'pathname'
require_relative '../lib/ip'


desc "Check the ip address of this machine"
task :ip do
	ip = Ip.new
	ips = ip.call
	if ips.length > 1
		puts "There is more than one interface with an ip address"
		ip.interfaces.each { |intf| puts "Interface: #{intf[:name]} ip address: #{intf[:ip]}" }
	else
		puts "The ip address is #{ips[0]}"	
	end
end
