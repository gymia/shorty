require 'rack/router'
require 'rack/lobster'
require 'json'

module Shorty
  module Application
    module_function

    def router
      Rack::Router.new do
        post "/shorten" => Shorty::Controllers::Create.new, as: "shorten"
      end
    end
  end
end
