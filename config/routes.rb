Rails.application.routes.draw do
  controller :tiny_urls do
    post :shorten, action: :create
    get ':shortcode', action: :show
    get ':shortcode/stats', action: :statistics
  end
end
