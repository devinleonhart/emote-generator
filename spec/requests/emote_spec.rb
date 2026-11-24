require "rails_helper"

RSpec.describe "Emote" do
  let(:probes) do
    ["../outside/secret", "./../outside/secret", "ada/../../outside/secret", "/outside/secret", "..\\outside\\secret",
     Rails.configuration.x.assets.join("outside/secret").to_s]
  end

  def ask(**)
    get "/emote", params: emote_query(**)
    response
  end

  it "gives a picture" do
    ask

    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Type"]).to eq("image/png")
    expect(response.headers["Cross-Origin-Resource-Policy"]).to eq("cross-origin")
    expect(response.headers["Cache-Control"]).to eq("max-age=604800, public")
    expect(pixel(response.body, 0, 0).size).to eq(4)
  end

  it "matches names in any case" do
    expect(ask(character: "ADA", eyes: "Xd").body).to eq(ask(eyes: "xd").body)
  end

  it "needs every part" do
    emote_query.each_key do |missing|
      get "/emote", params: emote_query.except(missing)
      expect([response.status, response.body, response.media_type]).to eq([400, "Bad Request", "text/plain"])
      expect(ask(missing => "")).to have_http_status(:bad_request)
      expect(ask(missing => { a: "b" })).to have_http_status(:bad_request)
      expect(ask(missing => ["normal"])).to have_http_status(:bad_request)
    end
  end

  it "knows only the catalog" do
    emote_query.each_key do |unknown|
      expect(ask(unknown => "nothing").status).to eq(404)
      expect([response.body, response.media_type]).to eq(["Not Found", "text/plain"])
    end
  end

  it "opens no file outside the parts" do
    allow(Vips::Image).to receive(:new_from_file).and_call_original
    probes.each do |probe|
      emote_query.each_key { |key| expect(ask(key => probe).status).to eq(404) }
    end
    ["%00", "%FF", "ada%00"].each do |raw|
      get "/emote?character=#{raw}&head=normal&eyebrows=normal&eyes=normal&mouth=normal"
      expect(response.status).to be_in([400, 404])
    end

    expect(Vips::Image).not_to have_received(:new_from_file)
  end

  it "takes the last of a repeated parameter" do
    get "/emote?character=nobody&character=ada&head=normal&eyebrows=normal&eyes=normal&mouth=normal"

    expect(response).to have_http_status(:ok)
  end
end
