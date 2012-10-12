class EventHandlerHash

  def initialize
    @events = Hash.new do |h,k|
      h[k] = Hash.new do |h,k|
        h[k] = Array.new
      end
    end
  end

  def add_event(event,id,&block)
    @events[event][id] = block
  end

  def delete(key, id = nil)
    if id.nil?
      @events.delete(key)
    else
      @events[key].delete(id)
    end
  end

  def fire(event, *args)
    @events[event].each_value do |block|
      block.call(*args)
    end
  end
end
