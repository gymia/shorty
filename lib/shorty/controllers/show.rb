require 'json'

module Shorty
  module Controllers
    class Show
      Success = lambda { |location|
        [302, {"CONTENT_TYPE" => "application/json", "Location" => location},
         [{}.to_json]]
      }

      Error = lambda { |error|
        content = [{ description: error[:message] }.to_json]
        [error[:code], {"CONTENT_TYPE" => "application/json"}, content]
      }

      def call(env)
        shortcode = env["rack.route_params"].fetch(:shorten, nil)

        shorty = Models::Shorty.find(shortcode)
        if shorty
          shorty.increment_redirect
          Success.call(shorty.shortened_url)
        else
          Error.call(Shorty::Errors.not_found)
        end
      end
    end
  end
end
