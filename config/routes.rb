Rails.application.routes.draw do
  post 'shorten', to: 'urls#shorten'
  get ':shortcode', to: 'urls#short_code'
  get ':shortcode/stats', to: 'urls#stats'
end
