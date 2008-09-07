require 'feed-normalizer'  
require 'open-uri'
require 'builder'

ENTRIES = (ARGV[0] || 50).to_i

class String
  def truncate(length)
    truncated = self[/.{0,#{length}}/]
    if truncated != self
      return truncated + '...'
    else
      return self
    end
  end
end

list_file = File.join(
  File.dirname(__FILE__), '..', 'config', 'feeds.txt' )

urls = File.read(list_file).strip.split(/\n/)

entries = urls.inject({}){ |hash, url|
  begin
    FeedNormalizer::FeedNormalizer.parse(open(url)).entries.each do |entry|
      next unless entry.title =~ /'[^']+'/ 
      hash[entry.urls.first] = entry
    end
  rescue => e
    $stderr.puts("Error: #{e.message}")
  end
  hash
}.values.sort_by{ |e| e.date_published }.reverse

buffer = ''
x = Builder::XmlMarkup.new(:target => buffer, :indent => 2)
x.ul do
  entries[0,ENTRIES].each do |entry|
    x.li do
      x.a(entry.title, :href => entry.urls.first)
      if entry.content.to_s != ''
        x.span(entry.content.truncate(100), :class => 'extended')
      end
    end
  end
end

puts buffer
