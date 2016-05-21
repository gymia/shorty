class TinyUrlsController < ApplicationController
  before_action :load_resource, only: [:show, :statistics]

  def create
    tiny_url = TinyUrl.new(resource_params)
    if tiny_url.save
      render json: tiny_url, status: :created
    elsif tiny_url.errors.include?(:url)
      render json: { error: 'url is not present.' }, status: 400
    elsif tiny_url.errors.has_error_on_attribute?(:taken, :shortcode)
      render json: {
          error: 'The desired shortcode is already in use. Shortcodes are case-sensitive.'
        }, status: 409
    elsif tiny_url.errors.has_error_on_attribute?(:invalid, :shortcode)
      render json: {
          error: "The shortcode fails to meet the following regexp: #{ TinyUrl::SHORTCODE_REGEX_STRING }."
        }, status: :unprocessable_entity
    end
  end

  def show
    render location: @tiny_url.url, status: 302
    @tiny_url.visit!
  end

  def statistics
    render json: @tiny_url, serializer: TinyUrlStatsSerializer
  end

  private
    def resource_params
      params.permit(:shortcode, :url)
    end

    def load_resource
      @tiny_url = TinyUrl.find_by(shortcode: params[:shortcode])
      unless @tiny_url
        render json: {
          error: "The '#{ params[:shortcode] }' cannot be found in the system"
        }, status: :not_found
      end
    end
end
