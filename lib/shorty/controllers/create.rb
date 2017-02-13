require 'json'

module Shorty
  module Controllers
    class Create < Base
      def call(env)
        req       = Rack::Request.new(env)
        url       = req.params["url"] || nil
        shortcode = req.params["shortcode"] || nil

        error = Shorty::Errors.missing_url
        return Error.call(error) if url.nil?

        shorty = Models::Shorty.new(url: url, shortcode: shortcode)
        if shorty.create
          Created.call({ url: shorty.url, shortcode: shorty.shortcode })
        else
          Error.call(shorty.error)
        end
      end
    end
  end
end
