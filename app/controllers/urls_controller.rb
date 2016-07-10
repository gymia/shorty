class UrlsController < ApplicationController
  before_action :find_url, except: :shorten

  def shorten
    @url = initialize_url
    @url.short_code = set_short_code
    @url.start_date = Time.current
    @url.save

    render json: { shortcode: @url.short_code }, status: 201
  end

  def short_code
    @url.update_attributes last_seen_date: Time.current,
                           redirect_count: @url.redirect_count + 1
    redirect_to @url.url
  end

  def stats
    render json: {
      startDate: @url.start_date.iso8601(3),
      lastSeenDate: @url.redirect_count == 0 ? nil : @url.last_seen_date.iso8601(3),
      redirectCount: @url.redirect_count
    }, status: 200
  end

  private

  def find_url
    @url = Url.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'The shortcode cannot be found in the system.' },
           status: 404
  end

  def initialize_url
    render json: { error: 'Url is not present.' },
           status: 400 and return unless params[:url].present?
    Url.new(url: params[:url])
  end

  def set_short_code
    if params[:shortcode].present?
      check_availability
      check_format
      params[:shortcode]
    else
      /^[0-9a-zA-Z_]{6}/.random_example
    end
  end

  def check_availability
    render json: { error: 'The the desired shortcode is already in use.' },
           status: 409 and return if Url.find_by(short_code: params[:shortcode]).present?
  end

  def check_format
    render json: { error: 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$.' },
           status: 422 and return if /^[0-9a-zA-Z_]{4,}$/.match(params[:shortcode]).nil?
  end
end
