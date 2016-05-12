require 'sinatra/json'

module Sinatra
  module ApiPresenter

    def respond_created(shortcode)
      status 201
      json :shortcode => shortcode
    end

    def respond_bad_request(message)
      status 400
      json :message => message
    end

    def respond_with_conflict(message)
      status 409
      json :message => message
    end

    def respond_with_unprocessable_entity(message)
      status 422
      json :message => message
    end

  end
end
