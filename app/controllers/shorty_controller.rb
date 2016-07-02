class ShortyController < ApplicationController

  def create
    render :json => { error: "url is not present"}, :status => 400 and return if params[:url].nil?
    @shortcode = Shortcode.create(shortcode_params)
    if @shortcode.errors.any?
      if @shortcode.errors.count == 1 && @shortcode.errors[:shortcode].first == "has already been taken"
        render :json => { error: @shortcode.errors.full_messages.to_sentence}, status: :conflict and return
      else
        render :json => { error: @shortcode.errors.full_messages.to_sentence}, status: :unprocessable_entity and return
      end
    end
    render :json => { "shortcode" => @shortcode.shortcode }
  end

  def redirect
    shortcode = Shortcode.find_by_shortcode(params[:shortcode])
    if shortcode
      redirect_to shortcode.url, status: 301
    else
      render json: {error: "The shortcode cannot be found in the system", status: 404}
    end
  end

  def stats
    render :json => {
        "startDate" => "2012-04-23T18:25:43.511Z",
        "lastSeenDate" => "2012-04-23T18:25:43.511Z",
        "redirectCount" => 1
    }
  end

  private
  def shortcode_params
    params.permit(:url,:shortcode)
  end

end
