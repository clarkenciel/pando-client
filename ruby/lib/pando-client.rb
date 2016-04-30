require 'optparse'
require 'json'
require 'websocket-eventmachine-client'
require 'osc-ruby'
require 'osc-ruby/em_server'

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

@args = Options.parse(ARGV)

if @args.keys.size >= 3
  # OSC Setup
  @pandoWs = nil
  pandoToOsc = OSC::Client.new(@args[:osc_target_host], @args[:osc_target_port])
  oscToPando = OSC::EMServer.new(@args[:osc_port])

  oscToPando.add_method '/pando/send_message' do | message |
    #puts "OSC /pando/send_message: #{message.address} #{message.to_a}"
    @pandoWs && @pandoWs.send(JSON.generate(
                               {type: 'message',
                                userName: message.to_a[1],
                                message: message.to_a[0]}))
  end

  # ws server
  EM.run do
    @pandoWs = WebSocket::EventMachine::Client.connect(
      :uri => "ws://#{@args[:phost]}/pando/api/connect/#{@args[:room]}/#{@args[:user]}")

    @pandoWs.onopen do
      puts "socket open"

      # kick off osc server and chuck program
      Thread.new do
        puts "listening to osc on: #{@args[:osc_port]}"
        oscToPando.run
        # execute chuck prog
      end
    end

    @pandoWs.onmessage do |msg, type|
      puts "received message: #{msg} of type: #{type}"
      pandoToOsc.send(OSC::Message.new(
                       "/pando/new_message",
                       msg['userName'],
                       msg['message'],
                       msg['frequency']
                     ))
    end

    @pandoWs.onclose do |code, reason|
      puts "socket closed"      
    end

    @pandoWs.onerror do |error|
      puts "error: #{error}"
    end

    EventMachine.add_periodic_timer(1) do
      @pandoWs.send(JSON.generate({type: "ping",
                                  userName: @args[:user],
                                  roomName: @args[:room]}))
    end
  end

else
  puts "Please provide at least the following options: --host HOST, --room ROOMNAME, --user USER"
end

