# Tries to reach the decoy outside the parts directory: ruby contract/traverse.rb <url> [header]

require_relative "replay"

base = ARGV.fetch(0)
headers = ARGV[1] ? [ARGV[1].split(": ", 2)].to_h : {}
all = { head: "normal", eyebrows: "normal", eyes: "normal", mouth: "normal" }
probes = ["../outside/secret", "..%2foutside%2fsecret", "./../outside/secret", "ada/../../outside/secret", "/app/assets/outside/secret", "../outside/secret\0"].map do |character|
  Contract.emote(character:, **all)
end
probes += ["/emote?character=..%2Foutside%2Fsecret&head=normal&eyebrows=normal&eyes=normal&mouth=normal",
           Contract.emote(head: "../../outside/secret_head_normal"), "/outside/secret_head_normal.png",
           "/..%2foutside/secret_head_normal.png", "/%2e%2e/outside/secret_head_normal.png", "/part/..%2foutside"]
reached = probes.select { |path| Contract.get(base, path, headers).then { |r| r.code == "200" && (r["content-type"] == "image/png" || r.body.include?("secret")) } }
reached.each { |path| puts "reached: #{path}" }
puts "#{reached.size} of #{probes.size} probes reached the decoy"
exit(reached.empty? ? 0 : 1)
