require_relative '../lib/shell_cmd'
require_relative '../lib/utils'

include ShellCmd

desc "Update istari setup to the latest version"
task :update do

	shell = Shell.new
	shell.call('git pull origin master').failed? { |r| notify_exit(r) }
	shell.call('bundle install').failed? { |r| notify_exit(r) }

end
