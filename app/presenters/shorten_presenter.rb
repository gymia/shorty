require_relative './api_presenter'
require_relative '../data/validator/validator'
require_relative '../services/url_service'

module Sinatra
  module ShortenPresenter

    def self.registered(app)
      app.helpers ApiPresenter
      app.before do
        @params = ::JSON.parse(request.body.read)
        @url_service = URLService.new
      end

      app.post '/shorten' do
        url = @params['url']
        shortcode = @params['shortcode']

        if Validator.blank?(url)
          return respond_bad_request "URL is not provided."
        end

        if !Validator.blank?(shortcode) && Validator.exists?(shortcode)
          return respond_with_conflict "Shortcode already exists"
        end

        if !Validator.blank?(shortcode) && !Validator.match?(shortcode)
          return respond_with_unprocessable_entity "Shortcode doesn't match regex"
        end

        short_url = @url_service.create(url, shortcode)

        respond_created short_url.shortcode
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
