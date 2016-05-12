require_relative './api_presenter'
require "sinatra/base"
require "sinatra/json"

module Sinatra
  module ShortenPresenter

    def self.registered(app)
      app.helpers ApiPresenter
      app.before do
        @params = ::JSON.parse(request.body.read)
      end

      app.post '/shorten' do
        url = @params['url']
        shortcode = @params['shortcode']

        if @params["url"].nil? || @params["url"].empty?
          return respond_bad_request "URL is not provided."
        end

        

        respond_created "URL created"
      end

      app.get '/:shortcode' do |shortcode|
        Exception.new "Not implemented"
      end

      app.get'/:shortcode/stats' do |shortcode|
        Exception.new "Not implemented"
      end

    end
  end
end
