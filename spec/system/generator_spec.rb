require "rails_helper"

RSpec.describe "Generator" do
  let(:errors) { page.driver.browser.evaluate("window.violations") }

  def preview = find("img[alt='Emote']")
  def query = Rack::Utils.parse_query(URI(preview[:src]).query)

  def choose_character(name)
    find_field("Character").click
    find("[role=option]", text: name).click
    expect(page).to have_field("Character", with: name)
  end

  def choose_all(**)
    emote_query(**).except(:character).each do |kind, name|
      within_fieldset(kind.to_s.capitalize) { find("label", text: name, exact_text: true).click }
    end
  end

  it "shows a complete random emote at first" do
    visit "/"

    expect(query.keys).to contain_exactly("character", "head", "eyebrows", "eyes", "mouth")
    expect(page.evaluate_async_script(<<~JS)).to eq(157)
      const image = document.querySelector("img[alt='Emote']")
      image.decode().then(() => arguments[0](image.naturalWidth), () => arguments[0]("broken"))
    JS
    expect(page).to have_css("input[type=radio]:checked", count: 4, visible: :all)
    expect(page).to have_field("Character", with: query["character"].capitalize)
    visit(query.then { |q| "/emote?#{Rack::Utils.build_query(q)}" })
    expect(page.status_code).to eq(200)
  end

  it "does not always show the same one" do
    seen = Array.new(12) { visit("/").then { query } }

    expect(seen.uniq.size).to be > 1
  end

  it "chooses random parts for a new character" do
    draw_part("ben_mouth_grin.png")
    visit "/?character=ada"
    choose_character "Ben"

    expect(page).to have_field("grin", type: :radio, visible: :all)
    expect(page).to have_css("input[type=radio]:checked", count: 4, visible: :all)
    expect(query).to include("character" => "ben")
    expect(page).to have_button("Copy URL", disabled: false)
  end

  it "does not always choose the same parts for a character" do
    seen = Array.new(12) { visit("/?character=ada").then { query } }

    expect(seen.uniq.size).to be > 1
  end

  it "shows no emote for a character without every part" do
    draw_part("cy_head_normal.png")
    visit "/?character=cy"

    expect(page).to have_text("No emote selected")
    expect(page).to have_button("Copy URL", disabled: true)
  end

  it "changes the preview with a part" do
    visit "/?character=ada"
    choose_all
    within_fieldset("Eyes") { find("label", text: "xd").click }

    expect(query["eyes"]).to eq("xd")
  end

  it "has a dropdown of characters, which is closed until it is used" do
    visit "/?character=ada"
    expect(page).to have_no_css("[role=option]")
    field = find_field("Character")
    field.click
    expect(all("[role=option]").map(&:text)).to eq(%w[Ada Ben])

    find("h2", text: "Preview").click
    expect(page).to have_no_css("[role=option]")
    expect(field.value).to eq("Ada")
  end

  it "filters the dropdown" do
    visit "/?character=ada"
    fill_in "Character", with: "BE"
    expect(all("[role=option]").map(&:text)).to eq(["Ben"])
    fill_in "Character", with: "zz"
    expect(page).to have_text("No characters match")
    find_field("Character").send_keys(:escape)

    expect(page).to have_field("Character", with: "Ada")
  end

  it "can be used with the keyboard" do
    visit "/?character=ada"
    find_field("Character").click
    find_field("Character").send_keys(:down, :down, :up, :enter)
    expect(page).to have_field("Character", with: "Ada")
    fill_in "Character", with: "be"
    find_field("Character").send_keys(:enter)

    expect(page).to have_field("Character", with: "Ben")
    expect(query).to include("character" => "ben")
  end

  it "copies the whole address" do
    visit "/?character=ada"
    page.execute_script("navigator.clipboard.writeText = async text => { window.copied = text }")
    choose_all
    click_button "Copy URL"

    expect(page).to have_button("Copied!")
    expect(page.evaluate_script("window.copied")).to eq(preview[:src]).and start_with("http")
  end

  it "fits a narrow screen, and breaks no policy" do
    page.driver.resize(360, 700)
    visit "/"
    page.execute_script(<<~JS)
      window.violations = []
      addEventListener("securitypolicyviolation", (event) => violations.push(event.violatedDirective))
    JS
    choose_character "Ben"
    choose_all

    expect(preview).to be_visible
    expect(page.evaluate_script("document.documentElement.scrollWidth")).to be <= 360
    expect(errors).to eq([])
    expect(page.driver.cookies).to be_empty
  end
end
