require 'rack/router'
require 'json'

module Shorty
  module Application
    module_function

    def router
      hello = ->(env) do
        [200, { 'Content-Type' => 'application/json' }, [ { x: 42 }.to_json ]]
      end

      Rack::Router.new do
        get "/" => hello
      end
    end
  end
end
