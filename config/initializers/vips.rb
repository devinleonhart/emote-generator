# After Nokogiri, whose own libxml would otherwise be replaced by the one libvips loads.
require "nokogiri"
require "vips"

# One request at a time uses few threads, and nothing is worth keeping between them.
Vips.concurrency_set(1)
Vips.cache_set_max(0)
