require 'rubygems'
require 'anemone'
require 'kconv'
require 'yaml'

config = YAML.load_file('config.yml')
url = config[:target_url]

Anemone.crawl(url, depth_limit: 1, proxy_host: 'localhost', proxy_port: 5432) do |anemone|
  anemone.focus_crawl do |page|
    # 条件に一致するリンクだけ残す
    # この `links` はanemoneが次にクロールする候補リスト
    page.links.keep_if do |link|
      # link.to_s.match(/anime/)
      link.to_s.match(/\/reviews\/recent_review\/page/)
    end
  end
  result = []
  anemone.on_every_page do |page|
    page.doc.xpath('//div[@class="recent_review_box_text"]').each do |node|
      hash = {
        url: page.url.to_s,
        review_title: node.search('[@class="rrbt_date"]').search('a').text,
        estimate: node.search('[@class="rrbt_star"]').text,
        sakuhin_title: node.search('[@class="rrbt_ttl"]').search('a').text
      }
      result.push hash
    end
  end
  anemone.after_crawl do
    tsv = result.map { |r| "#{r[:url]}\t#{r[:review_title]}\t#{r[:estimate]}\t#{r[:sakuhin_title]}"}
    tsv.each { |t| puts t }
  end
end
