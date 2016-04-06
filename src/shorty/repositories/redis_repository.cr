require "redis"

require "./base_repository"

class Shorty::RedisRepository < Shorty::BaseRepository
  def initialize(@connection : Redis)
  end

  def get(code)
    @connection.get(code).try do |json|
      UrlEntry.from_json(code, json)
    end
  end

  def put(url_entry)
    @connection.set(url_entry.code, url_entry.to_json)
  end

  def exists?(code)
    !@connection.get(code).nil?
  end
end

