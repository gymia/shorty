require 'sinatra/base'
require './config/config'
require './app/presenters/shorten_presenter'
class App < Sinatra::Base
    register Sinatra::Config
    register Sinatra::ShortenPresenter
end
