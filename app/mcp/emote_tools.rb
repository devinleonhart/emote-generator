module EmoteTools
  extend TailnetMcp::ToolSet

  def self.described(description) = text.merge(description:)

  tool("list_characters", :read, "List the characters that emotes can show") { Catalog.new.characters }

  tool("list_parts", :read, "List a character's parts: heads, eyebrows, eyes and mouths",
       { character: described("A name from list_characters") }) do |input, _|
    catalog = Catalog.new
    raise TailnetMcp::Refused, "Character not found" unless catalog.characters.include?(input[:character].downcase)

    catalog.parts(input[:character])
  end

  tool("generate_emote", :read, "Get the address of an emote, a picture of a character with the given parts", {
         character: described("A name from list_characters"),
         head: described("A head from list_parts"),
         eyebrows: described("Eyebrows from list_parts"),
         eyes: described("Eyes from list_parts"),
         mouth: described("A mouth from list_parts")
       }) do |input, _|
    emote = Emote.find(**input) || raise(TailnetMcp::Refused, "No such character or part")
    { url: emote.url }
  end
end
