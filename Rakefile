require 'tty-prompt'
require 'pathname'
require_relative 'lib/constants'
require_relative 'lib/shell_cmd'
require_relative 'lib/vbox_folders'
require_relative 'lib/utils'

Dir.glob('tasks/*.rake').each { |r| import r}

include ShellCmd
include Utils

prompt = TTY::Prompt.new

desc "Check the current working directory"
task :pwd do
	puts Rake.original_dir
end

desc "Check the dir that all new dungeons will be created in"
task :root do
	puts "New dungeons will be created in #{DUNGEONS_ROOT}"	
end

desc "List virtual box shared folders"
task :vbox_list do
	folders = VboxFolders.new.folders
	if folders.length == 0
		puts "There are no virtual box shared folders"
	else
		puts "The virtual box folders are: \n #{folders.join("\n")}"
	end 
	
end
