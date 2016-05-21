Rails.application.routes.draw do
  controller :tiny_urls do
    post :shorten, action: :create
  end
end
