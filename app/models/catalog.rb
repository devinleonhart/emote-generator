# The parts, read from their directory each time, so that new files appear at once.
# Names from outside are only compared with it, never made into a path.
class Catalog
  KINDS = %w[head eyebrows eyes mouth].freeze
  FILE = /\A(?<character>[a-z0-9]+)_(?<kind>#{KINDS.join('|')})_(?<name>[a-z0-9]+)\.png\z/

  def initialize(directory = Rails.configuration.x.assets.join("emotes"))
    @directory = directory
  end

  def characters
    matches.pluck(:character).uniq
  end

  def files(character = nil)
    found = character ? of(character) : matches
    found.map(&:string)
  end

  # The names of a character's parts, by kind.
  def parts(character)
    found = of(character)
    KINDS.index_with { |kind| found.select { |match| match[:kind] == kind }.pluck(:name) }
  end

  def path(character, kind, name)
    match = of(character).find { |one| one[:kind] == kind && one[:name] == name.downcase }
    @directory.join(match.string) if match
  end

  private

  def of(character)
    matches.select { |match| match[:character] == character.downcase }
  end

  def matches
    @directory.children.select(&:file?).filter_map { |file| FILE.match(file.basename.to_s) }.sort_by(&:string)
  end
end
