module MediocreBot
  module CoreDispatch

    def self.extended(obj)
      obj.instance_exec do
        module_name = "MediocreBot::CoreDispatch"
        register_event(module_name,module_name + '_handle_command','parsed_input') do |parsed_input|
          handle_command(parsed_input)
        end

        register_event(module_name,module_name + '_handle_ping','ping') do |input|
          handle_ping(input)
        end

        register_event(module_name,module_name +'_handle_001','001') do |input|
          handle_001(input)
        end

        register_event(module_name,module_name +'_handle_privmsg','privmsg') do |input|
          handle_privmsg(input)
        end

        register_event(module_name,module_name +'_debug','parsed_input') {|input| puts input.input_string}
      end
    end

    def post_init
      @state = :authenticating
      authenticate()
    end

    def receive_line(ln)
      parsed_input = IRCParser.new(ln)
      @events.fire('parsed_input',parsed_input)
    end

    # command event handlers
    def handle_command(parsed_input)
      fire(parsed_input.command,parsed_input)
    end

    def handle_authenticated
      #send_ns(@nickserv_password)
      join_channels(@channels)
    end

    def handle_001(input)
      if @state == :authenticating
        @state = :authenticated
      end
      handle_authenticated()
    end

    def handle_ping(input)
      send_pong(input.trailing)
    end

    def handle_privmsg(input)
      if input.middle[0] =~/^(#|&)/ # wonder if I will ever need a & channel
        input.channel = input.middle[0]
        input.parse_user_prefix!
        input.privmsg_type = :channel
        fire('channel_message',input)
      else
        input.parse_user_prefix!
        input.privmsg_type = :private
        fire('private_message',input)
      end
    end

    def handle_channel_message(input)

    end

    def handle_private_message(input)

    end


    # Methods for sending data to the server

    # Takes an irc message without a trailing newline and sends it
    def send_message(data)
      puts "<<< " + data 
      send_data(data + "\r\n")
    end

    def send_join(channel, key = nil)
      if key.nil?
        send_message("JOIN #{channel}")
      else
        send_message("JOIN #{channel} #{key}")
      end
    end

    def send_nick(nickname)
      send_message("NICK #{nickname}")
    end

    def send_ns(nickserv_password)
      send_message("NS IDENTIFY #{nickserv_password}")
    end

    def send_pong(deamon)
      send_message("PONG #{deamon}")
    end

    def send_user(username,real_name,hostname = '0', server_name = '*')
      send_message("USER #{username} #{hostname} #{server_name} :#{real_name}")
    end

    # Utility sending messages
    def authenticate()
      send_nick(@nick)
      send_user(@username,@real_name)
    end

    def join_channels(channels)
      channels.each do |channel|
        send_join(channel)
      end
    end

  end
end
