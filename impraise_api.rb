module Impraise
  class API < Grape::API
    format :json

    post :shorten do
      {you: "suck"}
    end
    get '/:shortcode' do
      params[:shortcode]
    end

    get '/:shortcode/stats' do
      "the shortcode #{params[:shortcode]} cant be found"
    end

  end
end