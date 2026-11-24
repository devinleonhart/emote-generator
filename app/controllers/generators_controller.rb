class GeneratorsController < ApplicationController
  def show
    # nginx lets every answer be kept, which would show one random emote for a week.
    no_store
    @catalog = Catalog.new
    @characters = @catalog.characters
    @character = params[:character].to_s if params[:character]
    @character = nil unless @characters.include?(@character)
    @character ? @parts = @catalog.parts(@character) : choose_at_random
  end

  private

  def choose_at_random
    @character = @characters.sample
    @parts = @character ? @catalog.parts(@character) : {}
    @chosen = @parts.transform_values(&:sample)
  end
end
