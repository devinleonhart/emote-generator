# A picture of a character, composed for each request and kept nowhere.
class Emote
  attr_reader :character, :parts

  # Parts by kind. Gives nil unless the catalog has all of them.
  def self.find(character:, catalog: Catalog.new, **parts)
    paths = Catalog::KINDS.map { |kind| catalog.path(character, kind, parts.fetch(kind.to_sym)) }
    new(character:, parts:, paths:) if paths.all?
  end

  def initialize(character:, parts:, paths:)
    @character = character.downcase
    @parts = parts.transform_values(&:downcase)
    @paths = paths
  end

  # Rounds after each step, as canvas did, so that emotes look as they always have.
  def to_png
    flat = @paths.map { |path| multiplied(Vips::Image.new_from_file(path.to_s).colourspace(:srgb)) }
                 .reduce { |below, above| above + (below * above[3].linear(-1, 255) / 255).rint }
    alpha = flat[3]
    # Where alpha is 0, vips gives 0.
    color = (flat.extract_band(0, n: 3) * 255 / alpha).rint
    color.bandjoin(alpha).cast(:uchar).copy(interpretation: :srgb).pngsave_buffer(keep: :none)
  end

  def url
    Rails.application.routes.url_helpers.emote_url(character:, **parts, **Rails.configuration.x.site)
  end

  private

  # Colors multiplied by their alpha, in whole numbers.
  def multiplied(image)
    alpha = image[3]
    (image.extract_band(0, n: 3) * alpha / 255).rint.bandjoin(alpha)
  end
end
