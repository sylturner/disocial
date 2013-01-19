require 'open-uri'
class FeedController < ApplicationController
  def index
    @updates = Friend.recent_updates
    respond_to do |format|
      format.html
      format.json { render json: @updates }
    end
  end
end
