require "option_parser"
require "./repositories/*"

class Shorty::Config
  getter host, port, environment, repository, redis_host, redis_port

  def initialize
    @host = "localhost"
    @port = 3000
    @environment = "development"
    @repository = "memory"
    @redis_host = "localhost"
    @redis_port = "6379"
  end

  def parse
    OptionParser.parse! do |opts|
      opts.on "-r REPOSITORY", "--repository REPOSITORY", "memory or redis (default: memory)" do |repository|
        if repository == "memory" || repository == "redis"
          @repository = repository
        else
          raise Exception.new("Repository option #{repository} is not defined!")
        end
      end

      opts.on "-rh REDIS_HOST", "--redis-host REDIS_HOST", "Redis host (deafult: localhost)" do |host|
        @redis_host = host
      end

      opts.on "-rp REDIS_PORT", "--redis-port REDIS_PORT", "Redis port (default: 6379)" do |port|
        @redis_port = port
      end

      opts.on("-b HOST", "--bind HOST", "Host to bind (defaults to 0.0.0.0)") do |host_binding|
        @host= host_binding
      end

      opts.on("-p PORT", "--port PORT", "Port to listen for connections (defaults to 3000)") do |opt_port|
        @port = opt_port.to_i
      end

      opts.on("-e ENV", "--environment ENV", "Environment [development, production] (defaults to development). Set `production` to boost performance") do |env|
        @environment = env
      end
    end
  end
end
