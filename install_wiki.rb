#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'
require 'open3'

TEMPLATE_URL = "https://github.com/Weltenbastler/template-mac.git"

# Print banner when arguments are missing
ARGV << '-h' if ARGV.count < 2

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__}.rb [options] <Git remote address> <path>"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  
  opts.on()
end.parse!

def abort(msg = "Aborting")
  puts msg
  exit -1
end

def guard_empty_dir(options)
  path = options[:path]
  abort("Directory not empty: #{path}") unless Dir["#{path}/*"].empty?
end

private def execute(command, options, error_msg = "Aborting")
  success = Open3.popen3(command, :chdir => options[:path]) do |stdin, stdout, stderr, wait_thr|
    stdin.close

    output = stdout.read.chomp
    puts output if options[:verbose]
  
    # Note: git writes output for humans to STDERR :(
    error = stderr.read.chomp
    puts error unless error.empty?

    wait_thr.value.success?
  end
  
  abort(error_msg) unless success  
end

def initialize_from_template(options)
  puts "Cloning from template ..."
  
  commands = [
    %Q(git clone #{TEMPLATE_URL} . #{"--progress" if options[:verbose]}),
    %Q(rm -rf .git),
    %Q(git init .),
    %Q(git add .),
    %Q(git commit -m "initialized from template")
  ]

  commands.each do |command| 
    execute(command, options)
  end
end

def configure_bundle(options)
  execute("bundle install", options, "Bundle installation failed")
end

def configure_git(options)
  commands = [
    %Q(git remote add origin #{options[:address]}),
    %Q(git push origin master),
  ]
  
  commands.each do |command| 
    execute(command, options)
  end
end

def build_initial_site(options)
  execute("bundle exec rake publish", options, "Building the initial site failed")
end


# 
# The actual command sequence 
#

path = ARGV.pop
options[:path] = File.expand_path(path, __dir__)
options[:address] = ARGV.pop

FileUtils.mkdir_p(options[:path])
guard_empty_dir(options)
initialize_from_template(options)
configure_bundle(options)
configure_git(options)
build_initial_site(options)
