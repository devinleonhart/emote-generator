class GeneratorsController < ApplicationController
  def show
    # nginx lets every answer be kept, which would show one random emote for a week.
    no_store
    catalog = Catalog.new
    @characters = catalog.characters
    @character = @characters.include?(params[:character]) ? params[:character] : @characters.sample
    @parts = @character ? catalog.parts(@character) : {}
    @chosen = @parts.transform_values(&:sample)
  end
end
