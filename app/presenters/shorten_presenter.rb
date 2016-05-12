require './app/presenters/api_presenter'
require './app/data/validator/validator'
require './app/services/short_code_service'

module Sinatra
  module ShortenPresenter

    def self.registered(app)
      app.helpers ApiPresenter

      app.before do
        @short_code_service = ShortCodeService.new
      end

      # Create a new shortened url
      app.post '/shorten' do

        body = request.body.read

        if body.empty?
          return respond_bad_request "URL is not provided."
        end

        params = {}
        params = ::JSON.parse(body)

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

        short_code_model = @short_code_service.create(url, shortcode)

        respond_created short_code.shortcode
      end

      # Get the url of a shortcode
      app.get '/:shortcode' do |shortcode|
        short_code_model = @short_code_service.get(shortcode)

        if short_code_model.nil?
          return respond_not_found "The shortcode cannot be found in the system"
        end

        @short_code_service.update(short_code_model)

        return respond_with_found short_code_model.url
      end

      # Get the stats of a shortcode
      app.get'/:shortcode/stats' do |shortcode|
        short_code_response = @short_code_service.get_stats(shortcode)

        if short_code_response.nil?
          return respond_not_found "The shortcode cannot be found in the system"
        end

        return respond_ok short_code_response
      end

    end
  end
end
