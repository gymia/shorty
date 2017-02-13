require 'json'

module Shorty
  module Controllers
    class Base
      Created = lambda { |shorty_hash|
        content = [shorty_hash.to_json]
        [201, {"CONTENT_TYPE" => "application/json"}, content]
      }

      Redirect = lambda { |location|
        [302, {"CONTENT_TYPE" => "application/json", "Location" => location},
         [{}.to_json]]
      }

      Success = lambda { |shorty_hash|
        content = [shorty_hash.to_json]
        [200, {"CONTENT_TYPE" => "application/json"}, content]
      }

      Error = lambda { |error|
        content = [{ description: error[:message] }.to_json]
        [error[:code], {"CONTENT_TYPE" => "application/json"}, content]
      }
    end
  end
end
