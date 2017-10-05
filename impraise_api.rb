require 'rack'
require 'rack/test'
require 'grape'
require 'active_record'
require 'otr-activerecord'
require 'sqlite3'
require_relative 'models/shortcode_data'
require 'introspective_grape'
#require 'byebug'
OTR::ActiveRecord.configure_from_file!('config/database.yml')

module Impraise
  class API < Grape::API
    format :json
    formatter :json, IntrospectiveGrape::Formatter::CamelJson
    get '/' do
      ShortcodeData.limit(1000)
    end

    post '/shorten' do
        shortcode = ShortcodeData.new(url: params[:url], shortcode: params[:shortcode])
        if shortcode.save
          return {shortcode: shortcode.shortcode}
        elsif shortcode.missing_url?
          status 400
        elsif shortcode.code_already_taken?
          status(409)
        elsif shortcode.code_invalid?
          status(422)
        else
          status(500)
        end
        return shortcode.errors.full_messages[0]
    end

    get '/:shortcode' do
      code = ShortcodeData.where(shortcode: params[:shortcode])
      if code.present?
        code = code.first
        code.last_seen_date = DateTime.now
        code.redirect_count = code.redirect_count + 1
        code.save!
        redirect code.url
      else
        status 404
        "The shortcode cannot be found in the system"
      end
    end

    get '/:shortcode/stats' do
      shortcode = ShortcodeData.find_by_shortcode(params[:shortcode])
      if shortcode.nil?
        status 404
        "Not found"
      else
        shortcode
      end
    end
  end
end