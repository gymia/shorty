require 'sinatra/json'

module Sinatra
  module ErrorHandler

    def self.registered(app)

      app.not_found do
        status 404
        json :message => "Oeps, are you sure you're at the right place?"
      end

      app.error 500 do
        status 500
        json :message => "Something went wrong. Please try again later"
      end
    end
  end
end
