require "rails_helper"

RSpec.describe "Page" do
  it "is never kept, since nginx lets everything be kept for a week" do
    get "/"

    expect(response).to have_http_status(:ok)
    expect(response.headers["Cache-Control"]).to eq("no-store")
    expect(response.headers["Set-Cookie"]).to be_nil
    expect(response.headers["Content-Security-Policy"]).to include("default-src 'self'")
  end

  it "copes with an empty catalog and odd parameters" do
    ["/?character=nobody", "/?character[]=ada", "/?character[a]=b"].each do |path|
      get path
      expect(response).to have_http_status(:ok)
    end
    emotes.glob("*.png").each(&:delete)
    get "/"
    expect(response.body).to include("No characters")
  end
end
