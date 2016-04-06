require "redis"
require "./resource_pool"
require "./repositories/*"

class Shorty::MemoryRepositoryHandler < HTTP::Handler
  def initialize
    @repository = MemoryRepository.new
  end

  def call(context)
    context.repository = @repository
    call_next(context)
  end
end

class Shorty::RedisRepositoryHandler < HTTP::Handler
  def initialize(host = "localhost", port = "6379")
    @pool = ResourcePool(RedisRepository).new do
      connection = Redis.new(host, port)
      RedisRepository.new(connection)
    end
  end

  def call(context)
    @pool.with do |repository|
      context.repository = repository
      call_next(context)
    end
  end
end
