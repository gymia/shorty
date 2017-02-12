require 'json'

module Shorty
  module Controllers
    class Create
      Success = lambda { |entity|
        content = [entity.to_json]
        [201, {"CONTENT_TYPE" => "application/json"}, content]
      }

      Error = lambda { |error|
        content = [{ description: error[:message] }.to_json]
        [error[:code], {"CONTENT_TYPE" => "application/json"}, content]
      }

      def call(env)
        req       = Rack::Request.new(env)
        url       = req.params["url"] || nil
        shortcode = req.params["shortcode"] || nil

        error = Shorty::Errors.missing_url
        return Error.call(error) if url.nil?

        entity = Shorty::ShortyEntity.new(url: url, shortcode: shortcode)
        if entity.create
          entity_hash = { url: entity.url, shortcode: entity.shortcode }
          Success.call(entity_hash)
        else
          Error.call(entity.error)
        end
      end
    end
  end
end
