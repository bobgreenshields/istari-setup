require_relative "shell_cmd"

COUNT_REG = /Shared Folder mappings\s*\((?<count>\d+)\)/m
FOLDER_REG = /^\d+\s+-\s+(?<folder>\S+)/
VB_CMD = "sudo VBoxControl sharedfolder list"

class VboxFolders
	attr_reader :stdout, :stderr

	def initialize(shell: ShellCmd::Shell.new)
		@shell = shell
	end

	def count(stdout = nil)
		unless stdout
			resp = @shell.call(VB_CMD)
			set_attr(resp)
			resp.failed?(&method(:raise_error))
			stdout = resp.stdout
		end
		match = COUNT_REG.match(stdout)
		if match
			match[:count].to_i
		else
			raise StandardError, "FAILED: could not find the number of shared folders in...\n#{resp.stdout}"	
		end
	end

	def folders
		result = []
		resp = @shell.call(VB_CMD)
		set_attr(resp)
		resp.failed?(&method(:raise_error))
		count = self.count(resp.stdout)
		resp.stdout.each_line do |line|
			match = FOLDER_REG.match(line)
			if match
				result << match[:folder]
			end
		end
		unless result.length == count
			raise StandardError, "FAILED: inconsistent number of folders between\n" \
				"Shared Folder mappings and individual folder items\n" \
				"Shared Folder mappings shows #{count}\n" \
				"Individuals folders shows #{result.length}\n" \
				"#{resp.stdout}"
		end
		result
	end

	def set_attr(resp)
		@stdout = resp.stdout
		@stderr = resp.stderr
	end

	def raise_error(response)
		raise StandardError, "Shell command failed: Command:#{response.cmd}\n#{response}"
	end
	
end

	#def intf_ips(addr_info)
		#result = addr_info.split(/^\d: /).map do |intf_str|
			#match = INTF_REG.match intf_str
			#match ? { name: match[:intf], ip: match[:ip] } : nil
		#end.
			#reject { |intf| intf.nil? }.
			#reject { |intf| intf[:name] == "lo" }
	#end


	#def call
		#resp = @shell.call(IP_CMD)
		#set_attr(resp)
		#resp.failed?(&method(:raise_error))
		#intf_ips(resp.stdout).map{ |intf| intf[:ip] }
	#end

	#def interfaces
		#resp = @shell.call(IP_CMD)
		#set_attr(resp)
		#resp.failed?(&method(:raise_error))
		#intf_ips(resp.stdout)
	#end

