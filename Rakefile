require 'tty-prompt'
require 'pathname'
require_relative 'lib/constants'
require_relative 'lib/shell_cmd'
require_relative 'lib/utils'

Dir.glob('tasks/*.rake').each { |r| import r}

include ShellCmd
include Utils

#DUNGEONS_ROOT = Pathname.pwd + "dungeons"
#DUNGEONS_ROOT = Pathname.new('/home/istari/dungeons')

#GIT_URL = 'https://github.com/bobgreenshields/deliverance.git'

#shell = Shell.new
prompt = TTY::Prompt.new

#desc "Create new dungeon/wilderness website"
#task :new do
	#name = prompt.ask "What is the name for the new site?" do |q|
		#q.required true
	#end

	#dungeon_name = sanitise(name)
	#dungeon_dir = DUNGEONS_ROOT + dungeon_name
	#puts "Looking for #{dungeon_dir}"
	#if dungeon_dir.exist?
		#puts "FAILED: the folder #{dungeon_dir} already exists"
		#exit
	#end
	#puts "Making directory #{dungeon_dir}"
	#dungeon_dir.mkdir
	#Dir.chdir(dungeon_dir) do
		#shell = Shell.new
		#shell.call('git init').failed? { |r| notify_exit(r) }
		#shell.call('git remote add origin https://github.com/bobgreenshields/deliverance.git').failed? { |r| notify_exit(r) }
		#shell.call('git pull origin master').failed? { |r| notify_exit(r) }
	#end
	#puts "#{dungeon_name} created"
	#if Rake.original_dir == "/home/istari"
		#puts "type...   cd dungeons/#{dungeon_name}"
	#end
	#if Rake.original_dir == "/home/istari/dungeons"
		#puts "type...   cd #{dungeon_name}"
	#end
  #puts "then type... rake -T"
  #puts "for commands to generate the new site"
#end

desc "Check the current working directory"
task :pwd do
	puts Rake.original_dir
end

desc "Check the dir that all new dungeons will be created in"
task :root do
	puts "New dungeons will be created in #{DUNGEONS_ROOT}"	
end
