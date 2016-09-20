require 'yaml'
require 'open-uri'
require 'uri'
require 'pathname'
require 'nokogiri'
require 'ostruct'

class PoemCrawler
  def extract_links
    ids = []
    Dir.glob($web_poems_src + 'lists/*.htm') do |path|
      puts "parsing #{path}"
      ids.concat parse_list(path)
    end
    ids = ids.uniq.sort
    puts "extracted #{ids.count} poems"
    File.write $web_poems_src + 'ids.yml', YAML.dump(ids)
  end

  def parse_list(path)
    content = File.read(path)
    ids = content.scan(/item_info\.php\?id=(\d+)/).flatten.map(&:to_i)
  end

  def download_links
    ids = YAML.load_file $web_poems_src + 'ids.yml'
    ids.each do |id|
      path = $web_poems_src + "poems/#{id}.html"
      unless File.exist?(path)
        uri = URI.parse "http://www.100bestpoems.ru/item_info.php?id=#{id}"
        puts "downloading #{uri}"
        File.write path, uri.read
        sleep 3
      end
    end
  end

  def parse_poems
    index = 121
    mapping = {}
    Pathname.glob($web_poems_src + "poems/*.html").shuffle.each do |path|
      begin
        mapping[index] = nil

        html = path.read
        doc = Nokogiri::HTML html, nil, "UTF-8"
        meta_block = doc.css('.table-bookinfo').first
        stats_block = doc.css('.block-statistics')

        data = OpenStruct.new
        data.ext_id = path.basename('.html').to_s.to_i
        data.title = doc.at("h1").text.strip
        data.author = meta_block.at('a[itemprop=author]').text.strip
        data.year = meta_block.at('td[itemprop=datePublished]').text.strip
        data.ext_position = stats_block.at('span:contains("Место в списке") b').text.strip
        data.ext_rating = stats_block.at('span:contains("Баллы") b').text.strip
        data.body = doc.at('span[itemprop=citation]').xpath('text()').map(&:text).join("\n").strip.
          gsub("\r", '').gsub(/(\n\s)+/, "\n")

        target_path = $poems_src / "#{index} #{data.author} #{data.title[0..30]}.txt"
        target_attrs = {'автор' => data.author, 'год' => data.year, 'название' => data.title}
        target_content = target_attrs.map { |k, v| "#{k}: #{v}" }.join("\n")
        target_content += "\n---\n#{data.body}"
        target_path.write target_content

        mapping[index] = data.ext_id
        index += 1
      rescue => error
        puts "File #{path} (#{index}): #{error}"
        path.delete
      end

      File.write $web_poems_src + 'mapping.yml', YAML.dump(mapping)
    end
  end
end
