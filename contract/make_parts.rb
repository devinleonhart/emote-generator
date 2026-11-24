# Draws made-up parts, so that no check needs the real ones: ruby contract/make_parts.rb <directory>
#
# Layers have opaque, half-transparent and empty areas, and differ for each name. A decoy
# lies outside the parts directory, where no request may reach it.

require "fileutils"
require "vips"
require "zlib"

WIDTH = 157
HEIGHT = 150
KINDS = { "head" => %w[normal tilt], "eyebrows" => %w[normal angry], "eyes" => %w[normal glee xd], "mouth" => %w[normal yell] }.freeze
CHARACTERS = %w[ada ben cy].freeze

# A colored ellipse with a soft edge, inside which a band is half transparent.
def layer(name, kind)
  random = Random.new(Zlib.crc32("#{name}/#{kind}"))
  color = Array.new(3) { random.rand(256) }
  scale = { "head" => 0.9, "eyebrows" => 0.5, "eyes" => 0.45, "mouth" => 0.4 }.fetch(kind)
  shift = { "head" => 0.0, "eyebrows" => -0.35, "eyes" => -0.1, "mouth" => 0.35 }.fetch(kind)
  bytes = String.new(capacity: WIDTH * HEIGHT * 4)
  HEIGHT.times do |y|
    WIDTH.times do |x|
      dx = ((x - (WIDTH / 2.0)) / (WIDTH / 2.0)) / scale
      dy = (((y - (HEIGHT / 2.0)) / (HEIGHT / 2.0)) - shift) / (scale * 0.8)
      distance = Math.sqrt((dx * dx) + (dy * dy))
      alpha = ((1.15 - distance) / 0.3).clamp(0.0, 1.0)
      alpha *= 0.5 if (x % 24) < 5
      bytes << [*color.map.with_index { |c, i| (c + ((x + (y * (i + 1))) / 3)) % 256 }, (alpha * 255).round].pack("C4")
    end
  end
  Vips::Image.new_from_memory(bytes, WIDTH, HEIGHT, 4, :uchar).copy(interpretation: :srgb)
end

def draw(directory, character)
  FileUtils.mkdir_p(directory)
  KINDS.each do |kind, names|
    names.each do |name|
      file = "#{character}_#{kind}_#{name}"
      layer(file, kind).pngsave(File.join(directory, "#{file}.png"))
    end
  end
end

root = ARGV.fetch(0)
CHARACTERS.each { |character| draw(File.join(root, "emotes"), character) }
draw(File.join(root, "outside"), "secret")
FileUtils.mkdir_p(File.join(root, "emotes/cache"))
%w[ada_normal old].each { |name| layer(name, "head").pngsave(File.join(root, "emotes/cache/#{name}.png")) }
