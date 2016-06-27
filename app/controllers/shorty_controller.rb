class ShortyController < ApplicationController

  def shorten
    render :json => { "shortcode" => "example" }
  end

  def shortcode
    render :json => { "shortcode" => "example" }
  end

  def stats
    render :json => {
        "startDate" => "2012-04-23T18:25:43.511Z",
        "lastSeenDate" => "2012-04-23T18:25:43.511Z",
        "redirectCount" => 1
    }
  end

end
