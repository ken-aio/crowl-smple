require 'cosmicrawler'

urls = %w(http://blog.takuros.net/entry/20140103/1388701372 http://blog.takuros.net/entry/20131223/1387814711)
Cosmicrawler.http_crawl(urls) do |request|
  get = request.get
  puts get.response if get.response_header.status == 200
end
