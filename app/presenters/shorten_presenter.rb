require_relative './api_presenter'
require_relative '../data/validator/validator'
require_relative '../services/short_code_service'

module Sinatra
  module ShortenPresenter

    def self.registered(app)
      app.helpers ApiPresenter
      app.before do
        @short_code_service = ShortCodeService.new
      end

      app.post '/shorten' do
        params = ::JSON.parse(request.body.read)
        url = params['url']
        shortcode = params['shortcode']

        if Validator.blank?(url)
          return respond_bad_request "URL is not provided."
        end

        if !Validator.blank?(shortcode) && Validator.exists?(shortcode)
          return respond_with_conflict "Shortcode already exists"
        end

        if !Validator.blank?(shortcode) && !Validator.match?(shortcode)
          return respond_with_unprocessable_entity "Shortcode doesn't match regex"
        end

        new_url = @short_code_service.create(url, shortcode)

        respond_created new_url.shortcode
      end

      app.get '/:shortcode' do |shortcode|
        url = @short_code_service.get(shortcode)

        if url.nil?
          return respond_bad_request "The shortcode cannot be found in the system"
        end

        @short_code_service.update(url)

        return respond_with_redirect url.url
      end

      app.get'/:shortcode/stats' do |shortcode|
        
      end

    end
  end
end
