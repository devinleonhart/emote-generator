require "rails_helper"

RSpec.describe "Catalog" do
  def json(path)
    get path
    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
    response.parsed_body
  end

  it "answers each route" do
    expect(json("/character")).to eq(%w[ada ben])
    expect(json("/part").size).to eq(16)
    expect(json("/part/ada")).to eq(json("/part/ADA")).and include("ada_head_normal.png").and have_attributes(size: 8)
    expect(json("/part/nobody")).to eq([])
    expect(json("/part/..%2foutside")).to eq([])
  end

  it "may be used and cached elsewhere, as nginx says too" do
    get "/character"

    expect(response.headers["Cross-Origin-Resource-Policy"]).to eq("cross-origin")
    expect(response.headers["Cache-Control"]).to eq("max-age=604800, public")
    expect(response.headers["Set-Cookie"]).to be_nil
  end

  it "keeps old emotes at their addresses" do
    FileUtils.cp(emotes.join("ada_head_normal.png"), cache.join("ada_normal.png"))
    FileUtils.touch(cache.join("notes.txt"))

    expect(json("/emote/cache")).to eq(["ada_normal.png"])
    get "/ada_normal.png"
    expect(response.headers["Content-Type"]).to eq("image/png")
    expect(response.body).to eq(cache.join("ada_normal.png").binread)
    expect(response.headers["Cross-Origin-Resource-Policy"]).to eq("cross-origin")
  end

  it "lists no old emotes without their directory" do
    cache.rmdir

    expect(json("/emote/cache")).to eq([])
  end

  it "serves nothing else by name" do
    FileUtils.cp(emotes.join("ada_head_normal.png"), cache.join("tmp.png"))
    ["/tmp.png", "/missing.png", "/ada_head_normal.png", "/../ada_head_normal.png", "/..%2fada_head_normal.png",
     "/%2e%2e/ada_head_normal.png", "/%2e%2e%2fada_head_normal.png", "/..%2f..%2foutside%2fsecret_head_normal.png",
     "/a%00.png", "/tmp.png%00", "/notes.txt"].each do |path|
      get path

      expect(response.status).to be_in([400, 404]), path
      expect(response.media_type).not_to eq("image/png")
    end
    expect(json("/emote/cache")).to eq([])
  end

  it "limits requests for each address" do
    Rails.cache.increment("rate-limit:all:127.0.0.1", 4997, expires_in: 1.hour)
    expect(Array.new(4) { get("/character") }).to eq([200, 200, 200, 429])
    expect(get("/emote")).to eq(429)
    expect(get("/character", headers: { "REMOTE_ADDR" => "203.0.113.9" })).to eq(200)
    expect(get("/up")).to eq(200)
  end
end
