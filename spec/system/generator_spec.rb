require "rails_helper"

RSpec.describe "Generator" do
  let(:errors) { page.driver.browser.evaluate("window.violations") }

  def preview = find("img[alt='Emote']")
  def query = Rack::Utils.parse_query(URI(preview[:src]).query)

  def choose_all(**)
    emote_query(**).except(:character).each { |kind, name| within_fieldset(kind.to_s.capitalize) { choose name } }
  end

  it "shows a complete random emote at first" do
    visit "/"

    expect(query.keys).to contain_exactly("character", "head", "eyebrows", "eyes", "mouth")
    expect(page.evaluate_async_script(<<~JS)).to eq(157)
      const image = document.querySelector("img[alt='Emote']")
      image.decode().then(() => arguments[0](image.naturalWidth), () => arguments[0]("broken"))
    JS
    expect(page).to have_css("input[type=radio]:checked", count: 4, visible: :all)
    expect(page).to have_link(query["character"].capitalize, class: "bb-btn-primary")
    visit(query.then { |q| "/emote?#{Rack::Utils.build_query(q)}" })
    expect(page.status_code).to eq(200)
  end

  it "does not always show the same one" do
    seen = Array.new(12) { visit("/").then { query } }

    expect(seen.uniq.size).to be > 1
  end

  it "clears the emote for a new character until every part is chosen" do
    draw_part("ben_mouth_grin.png")
    visit "/?character=ada"
    expect(page).to have_no_css("img[alt='Emote']")
    expect(page).to have_button("Copy URL", disabled: true)
    click_link "Ben"
    expect(page).to have_field("grin", type: :radio)
    expect(page).to have_text("No emote selected")

    choose_all
    expect(query).to eq(emote_query(character: "ben").stringify_keys)
    expect(page).to have_button("Copy URL", disabled: false)
    click_link "Ada"
    expect(page).to have_no_field("grin", type: :radio)
    expect(page).to have_no_css("img[alt='Emote']")
  end

  it "changes the preview with a part" do
    visit "/?character=ada"
    choose_all
    within_fieldset("Eyes") { choose "xd" }

    expect(query["eyes"]).to eq("xd")
  end

  it "finds characters" do
    visit "/"
    fill_in "Search characters", with: "BE"

    expect(page).to have_link("Ben")
    expect(page).to have_no_link("Ada")
    fill_in "Search characters", with: "zz"
    expect(page).to have_text("No characters match")
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
    click_link "Ben"
    choose_all

    expect(preview).to be_visible
    expect(page.evaluate_script("document.documentElement.scrollWidth")).to be <= 360
    expect(errors).to eq([])
    expect(page.driver.cookies).to be_empty
  end
end
