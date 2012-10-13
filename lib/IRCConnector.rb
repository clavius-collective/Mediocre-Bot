require 'eventmachine'
require './IRCParser.rb'
require './EventHandlerHash.rb'
# require './CoreDispatch.rb'
module MediocreBot
  class IRCConnector < EM::Connection
    include EM::Protocols::LineText2

    def initialize(config)
      @state = :unopened
      @port = config["port"]
      @server = config["server"]
      @username = config["username"]
      @real_name = config["real_name"]
      @nick = config["nick"]
      @nickserv_password = config["nickserv_password"]
      @channels = config["channels"]
      @events = EventHandlerHash.new
      @module_event_registration = Hash.new do |h,k|
        h[k] = Hash.new
      end
      @module_registration = Hash.new
      # extend MediocreBot::CoreDispatch
      load_module("./CoreDispatch.rb","MediocreBot::CoreDispatch")
    end

    def load_module(module_path,module_name)
      if @module_registration.has_key?(module_name)
        raise "Module already present"
      else
        load module_path
        @module_registration[module_name] = module_path
        eval "extend #{module_name}"
      end
    end
    
    def unload_module(module_name)
      unregister_event(module_name)
      @module_registration.delete(module_name)
    end

    def reload_module(module_name)
      path = @module_registration[module_name]
      unload_module(module_name)
      load_module(path,module_name)
    end

    def register_event(module_name, id, event, &block)
      @module_event_registration[module_name][id] = event
      @events.add_event(event,id,&block)
    end

    def unregister_event(module_name = nil, id = nil, event = nil)
      if module_name.nil? and id.nil? and not event.nil?
        @events.delete(event)
      elsif id.nil? and not event.nil?
        @module_event_registration[module_name].each_pair do |id,event|
          @events.delete(event,id)
          @module_event_registration[module_name].delete(id)
        end
      elsif module_name.nil? and not event.nil? and not id.nil?
        @events.delete(event,id)
        @module_event_registration.each do |module_name,module_hash|
          module_hash.delete(id)
        end
      elsif not module_name.nil? and event.nil? and id.nil?
        @module_event_registration[module_name].each do |id,event|
          @events.delete(event,id)
        end
        @module_event_registration.delete(module_name)
      end
    end

    def fire(event,*args)
      @events.fire(event,*args)
    end
  end
end
