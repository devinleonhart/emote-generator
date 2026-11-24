class PartsController < ApplicationController
  before_action :keep_for_a_week

  def index
    render json: Catalog.new.files
  end

  def show
    render json: Catalog.new.files(params.expect(:character))
  end

  def characters
    render json: Catalog.new.characters
  end
end
