class UrlsController < ApplicationController
  def shorten
    @url = initialize_url
    @url.shortcode = set_shortcode
    @url.start_date = DateTime.parse(Time.current).iso8601
    @url.save

    render json: { shortcode: @url.shortcode }, status: 201
  end

  def shortcode
  end

  def stats
  end

  private

  def initialize_url
    render(json: { error: 'Url is not present.' },
           status: 400) and return unless params[:url].present?
    Url.new(url: params[:url])
  end

  def set_shortcode
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
           status: 409 and return if Url.find_by(shortcode: params[:shortcode]).present?
  end

  def check_format
    render json: { error: 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$' },
           status: 422 and return if /^[0-9a-zA-Z_]{4,}$/.match(params[:shortcode]).nil?
  end
end
