# Emotes that the application once stored, which keep their addresses.
class CachedEmote
  # What the last request had drawn.
  SCRATCH = "tmp.png".freeze

  def self.names
    return [] unless directory.directory?

    directory.children.select { |file| file.file? && file.extname == ".png" }.map { |file| file.basename.to_s }.sort -
      [SCRATCH]
  end

  def self.path(name)
    directory.join(name) if names.include?(name)
  end

  def self.directory
    Rails.configuration.x.assets.join("emotes/cache")
  end
end
