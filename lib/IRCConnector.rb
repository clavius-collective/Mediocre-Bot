require 'eventmachine'
require './IRCParser.rb'
module IRCConnector < EM::Connection
  include EM::Protocols::LineText2
  
  def initialize(config)
    @state = :unopened
    @port = config["port"]
    @server = config["server"]
    @username = config["username"]
    @real_name = config["real_name"]
    @nick = config["nick"]
  end

  def post_init
    @state = :authenticating
    authenticate()
  end

  def recieve_line(ln)
    parsed_input = IRCParser.new(ln)
    command = parsed_input.command.downcase.to_sym
  end

  def authenticate()
    send_nick(@nick)
    send_user(@username,@real_name)
  end

  # Methods for sending data to the server


end
