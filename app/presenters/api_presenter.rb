module Sinatra
  module ApiPresenter

    def respond_created(message)
      status 201
      json :message => message
    end

    def respond_bad_request(message)
      status 400
      json :message => message
    end

  end
end
