require "kemal"
require "redis"
require "./shorty/**"

config = Shorty::Config.new
config.parse

if config.repository == "memory"
  Kemal.config.add_handler(Shorty::MemoryRepositoryHandler.new)
elsif config.repository == "redis"
  Kemal.config.add_handler(Shorty::RedisRepositoryHandler.new(config.redis_host, config.redis_port))
end

puts "Shorty running on #{config.repository} repository!"

def error(context, code, message)
  context.response.status_code = code
  { "message" => message }.to_json
end

def not_found(context)
  context.response.status_code = 404
  return { "message" => "The shortcode cannot be found in the system" }.to_json
end

post "/shorten" do |env|
  repository = env.repository
  code_generator = Shorty::CodeGenerator.new(repository)

  json = env.params.json

  unless json.has_key?("url")
    next error(env, 400, "url is not present")
  end

  url = json["url"].to_s

  if desired_code = json["shortcode"]?.try &.to_s
    unless code_generator.valid?(desired_code)
      next error(env, 422, "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$")
    end

    if repository.exists?(desired_code)
      next error(env, 409, "The the desired shortcode is already in use")
    end

    entry = Shorty::UrlEntry.new(desired_code, url)
  else
    entry = Shorty::UrlEntry.new(code_generator.generate, url)
  end

  repository.put(entry)

  { "shortcode" => entry.code }.to_json
end

# to prevent concurrent visit requests
visit_channel = Channel(Int32).new
spawn { visit_channel.send 0 }

get "/:shortcode" do |env|
  repository = env.repository

  code = env.params.url["shortcode"]

  visit_channel.receive

  if entry = repository.get(code)
    repository.put(entry.visit)
    env.redirect(entry.url)
    entry.url

    spawn { visit_channel.send 0 }
  else
    next not_found(env)
  end
end

get "/:shortcode/stats" do |env|
  repository = env.repository

  code = env.params.url["shortcode"]

  if entry = repository.get(code)
    entry.stats.to_json
  else
    next not_found(env)
  end
end

Kemal.config.host_binding = config.host
Kemal.config.port = config.port
Kemal.config.env = config.environment
Kemal.run

