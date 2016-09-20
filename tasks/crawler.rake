require File.expand_path(__dir__) + '/../lib/poem_crawler.rb'

namespace :crawler do
  task(:extract) { PoemCrawler.new.extract_links }
  task(:load) { PoemCrawler.new.download_links }
  task(:parse) { PoemCrawler.new.parse_poems }
end
