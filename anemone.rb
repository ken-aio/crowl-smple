require 'rubygems'
require 'anemone'
require 'kconv'

url = ARGV[0]

Anemone.crawl(url, depth_limit: 0, proxy_host: 'localhost', proxy_port: 5432) do |anemone|
  anemone.on_every_page do |page|
    puts page.url
    puts page.doc.at('title').text
  end
end
