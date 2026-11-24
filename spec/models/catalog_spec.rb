require "rails_helper"

RSpec.describe Catalog do
  subject(:catalog) { described_class.new }

  it "lists characters, parts and files" do
    expect(catalog.characters).to eq(%w[ada ben])
    expect(catalog.parts("ada")).to eq(Parts::NAMES.transform_values(&:sort))
    expect(catalog.files.size).to eq(16)
    expect(catalog.files("ada")).to all(start_with("ada_"))
    expect(catalog.files("ad")).to eq([])
  end

  it "ignores what is not a part" do
    ["notes.txt", "ada_nose_big.png", "ada_head.png", "ADA_head_x.png", "ada_head_a b.png", "ada_head_x.png.bak",
     ".ada_head_x.png"].each { |name| FileUtils.touch(emotes.join(name)) }
    emotes.join("ada_head_directory.png").mkpath

    expect(catalog.files.size).to eq(16)
  end

  it "notices an added and a removed file" do
    catalog.files
    draw_part("cy_head_normal.png")
    expect(catalog.characters).to eq(%w[ada ben cy])
    emotes.join("cy_head_normal.png").delete
    expect(catalog.characters).to eq(%w[ada ben])
  end

  it "finds names in any case, and nothing for others" do
    expect(catalog.path("ADA", "head", "Normal")).to eq(emotes.join("ada_head_normal.png"))
    ["../outside/secret", "./ada", "ada/", "", "nobody", "ada\0", "ada\n"].each do |name|
      expect(catalog.path(name, "head", "normal")).to be_nil
      expect(catalog.files(name)).to eq([])
    end
    expect(catalog.path("ada", "nose", "normal")).to be_nil
    expect(catalog.path("ada", "head", "../head_normal")).to be_nil
  end
end
