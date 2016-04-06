require "redis"

class Shorty::ResourcePool(T)
  def initialize(@size = 4, &@block : -> T)
    @channel = Channel(T).new
    initialize_resources
  end

  private def initialize_resources
    @size.times do
      spawn {
        @channel.send @block.call()
      }
    end
  end

  def release(resource)
    spawn {
      @channel.send resource
    }
  end

  def get
    @channel.receive
  end

  def with
    resource = get
    val = yield resource
    release(resource)

    return val
  end
end
