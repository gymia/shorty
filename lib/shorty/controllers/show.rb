require 'json'

module Shorty
  module Controllers
    class Show < Base
      def call(env)
        shortcode = env['rack.route_params'].fetch(:shorten, nil)
        shorty    = Models::Shorty.find(shortcode)

        if shorty && shorty.increment_redirect
          Redirect.call(shorty.shortened_url)
        else
          Error.call(Shorty::Errors.not_found)
        end
      end
    end
  end
end
