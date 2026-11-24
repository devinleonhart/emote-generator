require "vips"

# Compares pictures as they look: on black and on white, so that the hidden color of a
# transparent pixel does not count.
module Pictures
  module_function

  def read(bytes)
    image = Vips::Image.new_from_buffer(bytes, "")
    image = image.colourspace(:srgb)
    image.has_alpha? ? image : image.bandjoin(255)
  end

  # The greatest difference of any channel, of 255, or nil if the sizes differ.
  def difference(one, other)
    a = read(one)
    b = read(other)
    return unless a.size == b.size

    looks = [a, b].map { |image| [0, 255].map { |shade| image.flatten(background: [shade] * 3) } + [image.extract_band(3)] }
    looks[0].zip(looks[1]).map { |x, y| (x.cast(:int) - y.cast(:int)).abs.max }.max.round
  end
end
