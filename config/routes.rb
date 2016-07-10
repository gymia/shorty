Rails.application.routes.draw do
  post 'shorten', to: 'urls#shorten'
  get ':id', to: 'urls#short_code'
  get ':id/stats', to: 'urls#stats'
end
