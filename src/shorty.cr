require "kemal"
require "redis"
require "./shorty/**"

redis_connection = Redis.new
repository = Shorty::RedisRepository.new(redis_connection)
code_generator = Shorty::CodeGenerator.new(repository)

def error(context, code, message)
  context.response.status_code = code
  { "message" => message }.to_json
end

def not_found(context)
  context.response.status_code = 404
  return "The shortcode cannot be found in the system"
end

get "/" do
  "Hello world"
end

post "/shorten" do |env|
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

get "/:shortcode" do |env|
  code = env.params.url["shortcode"]

  if entry = repository.get(code)
    repository.put(entry.visit)
    env.redirect(entry.url)
    entry.url
  else
    next not_found(env)
  end
end

get "/:shortcode/stats" do |env|
  code = env.params.url["shortcode"]

  if entry = repository.get(code)
    entry.stats.to_json
  else
    next not_found(env)
  end
end

Kemal.run

