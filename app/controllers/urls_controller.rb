class UrlsController < ApplicationController
  before_action :find_url, except: :shorten

  def shorten
    render json: { error: 'Url is not present.' }, status: 400 and return unless params[:url].present?

    @url = Url.new(url: params[:url], short_code: params[:shortcode])

    if @url.save
      render json: { shortcode: @url.short_code }, status: 201
    elsif @url.errors.details[:short_code].first[:error] == :taken
      render json: { error: @url.errors[:short_code].first }, status: 409
    else
      render json: { error: @url.errors[:short_code].first }, status: 422
    end
  end

  def short_code
    @url.update_attribute(:redirect_count, @url.redirect_count + 1)
    redirect_to @url.url
  end

  def stats
    render json: {
      startDate: @url.created_at.iso8601(3),
      lastSeenDate: @url.redirect_count == 0 ? nil : @url.updated_at.iso8601(3),
      redirectCount: @url.redirect_count
    }, status: 200
  end

  private

  def find_url
    @url = Url.friendly.find(params[:shortcode])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'The shortcode cannot be found in the system.' },
           status: 404
  end
end
