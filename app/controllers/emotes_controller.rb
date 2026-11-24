class EmotesController < ApplicationController
  NAMES = [:character, *Catalog::KINDS.map(&:to_sym)].freeze

  def show
    names = params.permit(*NAMES).to_h.symbolize_keys
    return plain(:bad_request) unless NAMES.all? { |name| names[name].present? }

    emote = Emote.find(**names)
    emote ? picture(emote.to_png) : plain(:not_found)
  end
end
