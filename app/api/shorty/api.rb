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
        sc = ShortCode.create params.permit(:url, :shortcode)
        { shortcode: sc.short_code }
      end
    end
  end
end

