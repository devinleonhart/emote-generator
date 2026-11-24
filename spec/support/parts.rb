require "tmpdir"

# Parts drawn here, in a directory of each example's own. Beside it lies a decoy, outside.
module Parts
  NAMES = { "head" => %w[normal tilt], "eyebrows" => %w[normal angry], "eyes" => %w[normal xd],
            "mouth" => %w[normal yell] }.freeze

  # A picture in one color, with the given rectangle in another.
  def picture(color, area = nil, inside = nil, width: 157, height: 150)
    image = (Vips::Image.black(width, height, bands: 4) + color).cast(:uchar).copy(interpretation: :srgb)
    image = image.draw_rect(inside, *area, fill: true) if area
    image
  end

  def draw_part(name, image = picture([0, 0, 0, 0], [10, 10, 100, 100], [name.sum % 256, name.hash % 256, 90, 160]))
    emotes.mkpath
    image.pngsave(emotes.join(name).to_s)
  end

  def draw_character(character)
    NAMES.each { |kind, names| names.each { |name| draw_part("#{character}_#{kind}_#{name}.png") } }
  end

  def emotes = Rails.configuration.x.assets.join("emotes")
  def cache = emotes.join("cache")

  # The color of one pixel of a PNG.
  def pixel(bytes, left, top)
    Vips::Image.new_from_buffer(bytes, "").getpoint(left, top)
  end

  def emote_query(**)
    { character: "ada", head: "normal", eyebrows: "normal", eyes: "normal", mouth: "normal", ** }
  end
end

RSpec.configure do |config|
  config.include Parts

  config.around do |example|
    Dir.mktmpdir do |directory|
      kept = Rails.configuration.x.assets
      Rails.configuration.x.assets = Pathname(directory).join("assets")
      %w[ada ben].each { |character| draw_character(character) }
      cache.mkpath
      FileUtils.mkdir_p(Rails.configuration.x.assets.join("outside"))
      Parts::NAMES.each_key do |kind|
        FileUtils.cp(emotes.join("ada_#{kind}_normal.png"),
                     Rails.configuration.x.assets.join("outside/secret_#{kind}_normal.png"))
      end
      Rails.cache.clear
      example.run
    ensure
      Rails.configuration.x.assets = kept
    end
  end
end
