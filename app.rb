require 'sinatra/base'
require './config/config'
require './app/presenters/shorten_presenter'
require './app/data/repositories/repository'
require './app/data/repositories/short_code_repository'

class App < Sinatra::Base
    register Sinatra::Config
    register Sinatra::ShortenPresenter

    Repository::register(:shortcode, ShortCodeRepository.new)
end
