require 'sinatra/base'
require './config/config'
require './app/presenters/shorten_presenter'
require './app/data/repositories/repository'
require './app/data/repositories/url_repository'

class App < Sinatra::Base
    register Sinatra::Config
    register Sinatra::ShortenPresenter

    Repository::register(:url, UrlRepository.new)
end
