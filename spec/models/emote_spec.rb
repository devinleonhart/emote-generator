require "rails_helper"

RSpec.describe Emote do
  def emote(**) = described_class.find(**emote_query(**))

  # Whole layers, over each other.
  def draw_layers(colors)
    Parts::NAMES.keys.zip(colors) { |kind, color| draw_part("ada_#{kind}_normal.png", picture(color)) }
  end

  it "lays head, eyebrows, eyes and mouth over each other in this order" do
    clear = [0, 0, 0, 0]
    colors = [[10, 0, 0, 255], [0, 20, 0, 255], [0, 0, 30, 255], [40, 40, 0, 255]]
    4.times do |top|
      draw_layers(colors.each_with_index.map { |color, index| index <= top ? color : clear })

      expect(pixel(emote.to_png, 80, 70)).to eq(colors[top])
    end
  end

  it "has the parts' size and stays transparent" do
    draw_layers([[0, 0, 0, 0]] * 4)
    image = Vips::Image.new_from_buffer(emote.to_png, "")

    expect([image.width, image.height, image.bands]).to eq([157, 150, 4])
    expect(image.getpoint(0, 0).last).to eq(0)
  end

  it "blends half-transparent layers" do
    draw_layers([[200, 0, 0, 255], [0, 0, 200, 128], [0, 0, 0, 0], [0, 0, 0, 0]])
    pixel(emote.to_png, 5, 5).zip([100, 0, 100, 255]) { |got, wanted| expect(got).to be_within(2).of(wanted) }

    draw_layers([[0, 0, 0, 0], [0, 0, 200, 128], [0, 0, 0, 0], [0, 0, 0, 0]])
    pixel(emote.to_png, 5, 5).zip([0, 0, 200, 128]) { |got, wanted| expect(got).to be_within(2).of(wanted) }
  end

  it "is nil outside the catalog" do
    expect(emote(character: "nobody")).to be_nil
    Parts::NAMES.each_key { |kind| expect(emote(kind.to_sym => "nothing")).to be_nil }
    expect(emote(character: "../outside/secret")).to be_nil
  end

  it "knows its address" do
    expect(emote(character: "ADA", eyes: "XD").url)
      .to eq("https://emote.devleo.me/emote?character=ada&eyebrows=normal&eyes=xd&head=normal&mouth=normal")
  end
end
