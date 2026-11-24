# Asks for two emotes many times at once, and counts wrong pictures: ruby contract/race.rb <url>

require_relative "replay"

base = ARGV.fetch(0)
paths = [Contract.emote, Contract.emote(character: "ben", eyes: "glee", mouth: "yell")]
wanted = paths.map { |path| File.binread(Contract.picture_file(path)) }
wrong = Array.new(200) do |i|
  Thread.new do
    response = Contract.get(base, paths[i % 2])
    difference = response.code == "200" ? Pictures.difference(wanted[i % 2], response.body) : nil
    difference.nil? || difference > Contract::TOLERANCE
  rescue StandardError
    true
  end
end.count(&:value)
puts "#{wrong} wrong of 200"
exit(wrong.zero? ? 0 : 1)
