require_relative "shell_cmd"

INTF_REG =  /^\s*(?<intf>\S+):.*inet (?<ip>\d+\.\d+\.\d+\.\d+)/m
IP_CMD = "ls /sys/class/net"

class Ip
	def initialize(shell: ShellCmd::Shell.new)
		@shell = shell
	end

	def intf_ips(addr_info)
		result = addr_info.split(/^\d: /).map do |intf_str|
			match = INTF_REG.match intf_str
			match ? { name: match[:intf], ip: match[:ip] } : nil
		end.
			reject { |intf| intf.nil? }.
			reject { |intf| intf[:name] == "lo" }
	end

	def call
		resp = @shell.call(IP_CMD)
		resp.failed?(&method(:raise_error))
		intf_ips(resp.stdout).map{ |intf| intf[:ip] }
	end

	def interfaces
		resp = @shell.call(IP_CMD)
		resp.failed?(&method(:raise_error))
		intf_ips(resp.stdout)
	end

	def raise_error(response)
		raise StandardError, "Shell command failed: Command:#{response.cmd}\n#{response}"
	end
	
end
