require "rails_helper"

RSpec.describe "MCP" do
  include_context "with tailnet MCP"

  it_behaves_like "a tailnet MCP endpoint", tool: "list_characters", page: "/character"

  it "offers three tools to a token that reads" do
    expect(tool_names(reader)).to contain_exactly("list_characters", "list_parts", "generate_emote")
  end

  it "lists characters and parts" do
    expect(tool_data("list_characters", token: reader)).to eq(%w[ada ben])
    expect(tool_data("list_parts", { character: "Ada" }, token: reader))
      .to eq(Parts::NAMES.transform_values(&:sort))
  end

  it "gives an emote's address, not its data" do
    text = tool_text("generate_emote", emote_query(eyes: "XD"), token: reader)
    address = URI(JSON.parse(text).fetch("url"))
    expect(text.size).to be < 200

    expect(address.host).to eq("emote.devleo.me")
    get address.request_uri
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("image/png")
  end

  it "refuses unknown names" do
    expect(tool_error("list_parts", { character: "nobody" }, token: reader)).to eq("Character not found")
    expect(tool_error("list_parts", { character: "../outside/secret" }, token: reader)).to eq("Character not found")
    emote_query.each_key do |unknown|
      expect(tool_error("generate_emote", emote_query(unknown => "nothing"), token: reader))
        .to eq("No such character or part")
    end
    expect(tool_error("generate_emote", emote_query.except(:head), token: reader)).to be_present
  end

  it "refuses another application's token" do
    allow(TailnetMcp.configuration).to receive(:token_prefix).and_return("bbk")
    other = issue_token
    allow(TailnetMcp.configuration).to receive(:token_prefix).and_call_original

    expect(reader).to start_with("emo_")
    expect(mcp_status(token: other)).to eq(401)
  end

  describe "the hosts in production" do
    # The middleware as production configures it.
    def guarded(host, path)
      exclude = ->(request) { ["/up", "/mcp"].include?(request.path) }
      app = ActionDispatch::HostAuthorization.new(->(_env) { [200, {}, []] }, ["emote.devleo.me"], exclude:)
      app.call(Rack::MockRequest.env_for(path, "HTTP_HOST" => host)).first
    end

    let(:mcp_host) { TailnetMcp::RSpecHelpers::HOST }

    it "are split as production.rb says" do
      source = Rails.root.join("config/environments/production.rb").read
      expect(source).to include('config.hosts = [ENV.fetch("APP_HOST", "emote.devleo.me")]')
      expect(source).to include('exclude: ->(request) { ["/up", "/mcp"].include?(request.path) }')

      expect(guarded(mcp_host, "/character")).to eq(403)
      expect(guarded("emote.devleo.me", "/character")).to eq(200)
      expect(mcp_status(host: "emote.devleo.me", token: reader)).to eq(403)
    end
  end
end
