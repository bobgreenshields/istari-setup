require 'tty-prompt'
require 'pathname'
require_relative 'lib/constants'
require_relative 'lib/shell_cmd'
require_relative 'lib/vbox_folders'
require_relative 'lib/utils'

Dir.glob('tasks/*.rake').each { |r| import r}

MNT_CMD = "sudo mount -t vboxsf -o rw,uid=1000,gid=1000 dungeons #{DUNGEONS_ROOT}"

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

desc "Setups the machine to run istari, mounts dungeons shared folder"
task :setup do
	folders = VboxFolders.new.folders
	unless folders.include? "dungeons"
		puts "FAILED: there is no shared folder dungeons"
		puts "Add the shared folder from the main virtual box application"
		puts "and then rerun."
		exit
	end
	shell = Shell.new
	if shell.call("mountpoint #{DUNGEONS_ROOT}").succeeded?
		puts "Folder dungeons is already mounted on #{DUNGEONS_ROOT}"
	else
		resp = shell.call(MNT_CMD)
		resp.failed? { |r| notify_exit(r) }
		if shell.call("mountpoint #{DUNGEONS_ROOT}").succeeded?
			puts "Folder dungeons has been successfully mounted on #{DUNGEONS_ROOT}"
		else
			puts "FAILED: the folder dungeons could not be mounted on #{DUNGEONS_ROOT}"
			puts resp
			exit
		end
	end
end
