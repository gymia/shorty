require 'json'

module Shorty
  module Controllers
    class Stats < Base
      def call(env)
        shortcode = env['rack.route_params'].fetch(:shorten, nil)
        shorty    = Models::Shorty.find(shortcode)

        if shorty
          mount_response_hash(shorty)
          Success.call(shorty_hash)
        else
          Error.call(Shorty::Errors.not_found)
        end
      end

      private
      attr_reader :shorty_hash

      def mount_response_hash(shorty)
        @shorty_hash = {
          startDate: shorty.start_date,
          redirectCount: shorty.redirect_count
        }
        last_seen_date = shorty.last_seen_date
        @shorty_hash.merge!({lastSeenDate: last_seen_date}) if last_seen_date
      end
    end
  end
end
