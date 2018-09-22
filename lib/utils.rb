module Utils
	module_function

	def sanitise(name)
		name.strip.downcase.gsub(/[^a-z0-9\.]+/,"-").gsub(/-\./, ".")
	end

	def notify_exit(response)
			puts "\e[91mFAILED\e[0m: shell cmd: #{response.cmd}"
			puts response
			exit 100
	end
end
