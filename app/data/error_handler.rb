require 'sinatra/json'

module Sinatra
  module ErrorHandler

    def self.registered(app)

      app.error 500 do
        status 500
        json :message => "Something went wrong. Please try again later"
      end
    end
  end
end
