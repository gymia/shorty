require_relative './api_presenter'
require_relative '../data/validator/validator'

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

        if Validator.blank?(url)
          return respond_bad_request "URL is not provided."
        end

        if Validator.exists?(shortcode)
          return respond_with_conflict "Shortcode already exists"
        end

        if !Validator.match?(shortcode)
          return respond_with_unprocessable_entity "Shortcode doesn't match regex"
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
