module Shorty
  class API < Grape::API
    format :json
    resource :shorten do
      desc "Create a short URL."
      params do
        requires :url, type: String, desc: "URL to shorten"
        optional :shortcode, type: String, desc: 'Preferential shortcode'
      end
      post do
        status 201
      end
    end
  end
end

