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

    resource '/' do
      get ':shortcode' do
        sc = ShortCode.find_by_shortcode(params[:shortcode])
        if sc
          ShortCode.increment_counter(:hits, sc.id)
          sc.touch
          return redirect sc.url
        end
        error! 'The shortcode cannot be found in the system', 404
      end

      get ':shortcode/stats' do
        sc = ShortCode.find_by_shortcode(params[:shortcode])
        if sc
          return {
            'startDate' => sc.created_at,
            'lastSeenDate' => sc.updated_at,
            'redirectCount' => sc.hits
          }
        end
        error! 'The shortcode cannot be found in the system', 404
      end
    end
  end
end

