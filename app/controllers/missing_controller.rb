class MissingController < ApplicationController
  def show
    render file: Rails.public_path.join("404.html"), layout: false, status: :not_found
  end
end
