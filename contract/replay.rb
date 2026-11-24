# Records the application's answers over the made-up parts, and compares later ones.
#
#   ruby contract/replay.rb record <url>
#   ruby contract/replay.rb verify <url> [--only json,cached,emote] [--unknown 404]
#
# JSON lists are compared without their order, which was the file system's.

require "json"
require "net/http"
require "optparse"
require "uri"
require_relative "pictures"

module Contract
  DIR = __dir__
  GOLDEN = File.join(DIR, "golden.json")
  TOLERANCE = 2
  HEADERS = %w[content-type cross-origin-resource-policy].freeze
  KINDS = %w[head eyebrows eyes mouth].freeze

  def self.emote(**)
    "/emote?#{URI.encode_www_form({ character: 'ada', head: 'normal', eyebrows: 'normal', eyes: 'normal', mouth: 'normal' }.merge(**))}"
  end

  REQUESTS = {
    "json" => %w[/character /part /part/ada /part/BEN /part/nobody /part/ad /emote/cache],
    "cached" => %w[/ada_normal.png /old.png /missing.png],
    "emote" => [
      emote, emote(character: "ben", eyes: "glee", mouth: "yell"), emote(character: "cy", head: "tilt", eyebrows: "angry"),
      emote(character: "CY", head: "Normal", eyes: "XD", mouth: "YELL"), emote(eyes: "xd", mouth: "yell", head: "tilt"),
      "/emote", *KINDS.map { |kind| emote.sub(/&#{kind}=[^&]*/, "") }, emote.sub("character=ada&", ""), emote(character: "")
    ],
    "unknown" => [emote(character: "nobody"), *KINDS.map { |kind| emote(kind.to_sym => "nothing") }]
  }.freeze

  module_function

  def get(base, path, headers = {})
    uri = URI.join(base, path)
    request = Net::HTTP::Get.new(uri)
    headers.each { |name, value| request[name] = value }
    Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
  end

  def picture_file(path)
    File.join(DIR, "golden", "#{path.gsub(/[^A-Za-z0-9]+/, '_')}.png")
  end

  def facts(response)
    facts = { "status" => response.code.to_i, "headers" => HEADERS.to_h { |name| [name, response[name]] } }
    facts["body"] = JSON.parse(response.body).sort if response["content-type"].to_s.include?("json")
    facts["body"] = response.body if response["content-type"].to_s.start_with?("text/plain")
    facts
  end

  def record(base, _options)
    golden = REQUESTS.values.flatten.to_h do |path|
      response = get(base, path)
      File.binwrite(picture_file(path), response.body) if response["content-type"] == "image/png"
      [path, facts(response)]
    end
    File.write(GOLDEN, "#{JSON.pretty_generate(golden)}\n")
    puts "#{golden.size} answers recorded"
    true
  end

  def verify(base, options)
    golden = JSON.parse(File.read(GOLDEN))
    paths = REQUESTS.slice(*(options[:only] || REQUESTS.keys)).values.flatten
    bad = paths.count do |path|
      found = differences(golden.fetch(path), get(base, path, options[:headers]), path, options)
      found.each { |line| puts "#{path}: #{line}" }
      found.any?
    end
    puts "#{paths.size} answers compared, #{bad} differences"
    bad.zero?
  end

  def differences(expected, response, path, options)
    actual = facts(response)
    expected = adjusted(expected, path, options)
    keys = expected.keys | actual.keys
    found = keys.reject { |key| expected[key] == actual[key] }.map { |key| "#{key}: expected #{expected[key].inspect}, got #{actual[key].inspect}" }
    return found unless response["content-type"] == "image/png" && expected["status"] == 200

    difference = Pictures.difference(File.binread(picture_file(path)), response.body)
    found << "picture differs by #{difference.inspect}" if difference.nil? || difference > TOLERANCE
    found
  end

  # An unknown name may be given another status, whose text then differs too.
  def adjusted(expected, path, options)
    return expected unless options[:unknown] && REQUESTS["unknown"].include?(path)

    status = Integer(options[:unknown])
    expected.merge("status" => status, "body" => Net::HTTPResponse::CODE_TO_OBJ.fetch(status.to_s).name[/HTTP(.*)/, 1].gsub(/(?<=[a-z])(?=[A-Z])/, " "))
  end

  def main(argv)
    options = { headers: {} }
    command, base = OptionParser.new do |parser|
      parser.on("--only SECTIONS", Array) { |value| options[:only] = value }
      parser.on("--unknown STATUS") { |value| options[:unknown] = value }
      parser.on("--header HEADER") { |value| options[:headers].store(*value.split(": ", 2)) }
    end.parse(argv)
    abort "Usage: replay.rb record|verify URL" unless %w[record verify].include?(command) && base

    public_send(command, base, options)
  end
end

exit(Contract.main(ARGV) ? 0 : 1) if $PROGRAM_NAME == __FILE__
