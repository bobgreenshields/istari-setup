require "open3"

module ShellCmd
	class Response
		attr_reader :cmd, :stdout, :stderr, :exit_code

		def initialize(cmd:, stdout:, stderr:, status:)
			@cmd = desplat(cmd)
			@stdout = stdout
			@stderr = stderr
			@exit_code = status.exitstatus
		end

		def desplat(cmd)
			res = Array(cmd)
			if res[0].instance_of? Hash
				res.shift
			end
			res.join(" ")
		end

		def succeeded?
			if block_given? && @exit_code == 0
				yield self
				true
			else
				@exit_code == 0
			end
		end

		def failed?
			if block_given? && !(@exit_code == 0)
				yield self
				true
			else
				!(@exit_code == 0)
			end
		end

		def to_s
			@stdout + @stderr
		end
	end

	class Shell
		def call(*cmd)
			stdout, stderr, status = Open3.capture3(*cmd)			
			Response.new(cmd: cmd, stdout: stdout, stderr: stderr, status: status)
		end
	end


end
