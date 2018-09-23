require 'tty-prompt'
require 'pathname'
require_relative '../lib/constants'
require_relative '../lib/shell_cmd'
require_relative '../lib/utils'

include ShellCmd
include Utils


prompt = TTY::Prompt.new

desc "Create new dungeon/wilderness website"
task :new do
	unless DUNGEONS_ROOT.exist?
		puts "FAILED: the root folder for dungeons #{DUNGEONS_ROOT} does not exist"
		exit
	end

	name = prompt.ask "What is the name for the new site?" do |q|
		q.required true
	end

	dungeon_name = sanitise(name)
	dungeon_dir = DUNGEONS_ROOT + dungeon_name
	puts "Looking for #{dungeon_dir}"
	if dungeon_dir.exist?
		puts "FAILED: the folder #{dungeon_dir} already exists"
		exit
	end
	puts "Making directory #{dungeon_dir}"
	dungeon_dir.mkdir
	Dir.chdir(dungeon_dir) do
		shell = Shell.new
		shell.call('git init').failed? { |r| notify_exit(r) }
		shell.call('git remote add origin https://github.com/bobgreenshields/deliverance.git').failed? { |r| notify_exit(r) }
		shell.call('git pull origin master').failed? { |r| notify_exit(r) }
		shell.call('git branch -u origin/master').failed? { |r| notify_exit(r) }
	end
	puts "#{dungeon_name} created"
	if Rake.original_dir.to_s == DUNGEONS_ROOT.parent.to_s
		puts "type...   cd dungeons/#{dungeon_name}"
	end
	if Rake.original_dir.to_s == DUNGEONS_ROOT.to_s
		puts "type...   cd #{dungeon_name}"
	end
  puts "then type... rake -T"
  puts "for commands to generate the new site"
end
