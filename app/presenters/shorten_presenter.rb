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

        short_code = @short_code_service.create(url, shortcode)

        respond_created short_code.shortcode
      end

      app.get '/:shortcode' do |shortcode|
        short_code = @short_code_service.get(shortcode)

        if short_code.nil?
          return respond_not_found "The shortcode cannot be found in the system"
        end

        @short_code_service.update(short_code)

        return respond_with_found short_code.url
      end

      app.get'/:shortcode/stats' do |shortcode|
        short_code = @short_code_service.get_stats(shortcode)

        if short_code.nil?
          return respond_not_found "The shortcode cannot be found in the system"
        end

        return respond_ok short_code
      end

    end
  end
end
