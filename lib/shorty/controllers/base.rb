require 'json'

module Shorty
  module Controllers
    class Base
      Created = lambda { |shorty_hash|
        [201, content_type, [shorty_hash.to_json]]
      }

      Redirect = lambda { |location|
        [302, content_type.merge!({'Location' => location}), [{}.to_json]]
      }

      Success = lambda { |shorty_hash|
        [200, content_type, [shorty_hash.to_json]]
      }

      Error = lambda { |error|
        [error[:code], content_type, [{ description: error[:message] }.to_json]]
      }

      private
      def self.content_type
        { 'CONTENT_TYPE' => 'application/json' }
      end
    end
  end
end
