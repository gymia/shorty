require 'rack/router'
require 'rack/lobster'
require 'json'

module Shorty
  module Application
    module_function

    def router
      Rack::Router.new do
        post "/shorten" => Shorty::Controllers::Create.new, as: "create"
        get "/:shorten" => Shorty::Controllers::Show.new, as: "show"
      end
    end
  end
end
