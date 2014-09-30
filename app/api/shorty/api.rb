module Shorty
  class API < Grape::API
    format :json
    resource :shorten do
      desc "Create a short URL."
      params do
        requires :url, type: String, desc: "URL to shorten"
        optional :shortcode, type: String, desc: 'Preferential shortcode', regexp: /^[0-9a-zA-Z_]{4,}$/
      end

      # This is hacky way to return custom HTTP Status codes otherwise
      # Grape::Exceptions::Base has :status, but I'm not sure how to access it
      rescue_from Grape::Exceptions::ValidationErrors do |e|
        status = 400
        e.errors.keys.each do |key|
          status = 422 if key.first == 'shortcode'
        end
        rack_response e.to_json, status
      end

      post do
        # Using params.permit(:url, :shortcode) fails
        fields = {
          url: params[:url],
          shortcode: params[:shortcode]
        }

        begin
          sc = ShortCode.create!(fields)
        rescue ActiveRecord::RecordInvalid
          status 409
          return
        end

        { shortcode: sc.shortcode }
      end

    end

    get '/:shortcode' do
      puts params.inspect
      sc = ShortCode.find_by_shortcode(params[:shortcode])
      if sc
        return redirect sc.url
      end
      error! 'The shortcode cannot be found in the system', 404
    end
  end
end

