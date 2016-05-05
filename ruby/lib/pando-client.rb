require 'optparse'
require 'json'
require 'net/http'
require 'websocket-eventmachine-client'
require 'osc-ruby'
require 'osc-ruby/em_server'

module PandoClient
  %w[
    chuck/chuck
    pando/pando
    osc/osc
    modes/modes
    views/views
  ].each { |f| require_relative f }
end

class Options
  def self.parse(args)
    opts = {}
    opts[:osc_port] = 5730
    opts[:osc_target_host] = "localhost"
    opts[:osc_target_port] = 5731
    parser = OptionParser.new do |opt|  
      opt.on('--pando-host HOST')       { |o| opts[:phost] = o }
      opt.on('--room ROOM')             { |o| opts[:room] = o }
      opt.on('--user USER')             { |o| opts[:user] = o }
      opt.on('--osc-port PORT')         { |o| opts[:osc_port] = o }
      opt.on('--osc-target-host HOST')  { |o| opts[:osc_target_host] = o }
      opt.on('--osc-target-port PORT')  { |o| opts[:osc_target_port] = o}
    end
    parser.parse!(args)
    opts
  end
end # class Options

# @args = Options.parse(ARGV)

# if @args.keys.size >= 3

# else
#   puts "Please provide at least the following options: --host HOST, --room ROOMNAME, --user USER"
# end

