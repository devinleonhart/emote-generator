class CachedEmotesController < ApplicationController
  def index
    keep_for_a_week
    render json: CachedEmote.names
  end

  def show
    path = CachedEmote.path(params[:name])
    path ? picture(path.binread) : missing
  end

  private

  def missing
    render file: Rails.public_path.join("404.html"), layout: false, status: :not_found
  end
end
