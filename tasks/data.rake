$original_poems_dir = Pathname.new "assets/poems-src-2"
$utf8_poems_dir = Pathname.new "assets/poems-utf-2"

require 'shellwords'

module PoemSources
  module_function

  def poem_id_for_date(date)
    date.strftime("%Y%m%d").to_i
  end

  def all_sources
    Pathname.glob($poems_src / "*.txt").sort_by { |path| path.basename.to_s.to_i }.each_with_index do |src, index|
      basename = File.basename(src, '.txt')
      text = File.read(src)
      text = text.gsub("\r", "")
      header, body = text.split("---\n", 2)

      tag_lines = header.split("\n")
      tags = tag_lines.each_with_object({}) do |line, map|
        name, value = line.split(/\: ?/)
        map[name] = value
      end

      yield src, index, tags, body, basename
    end
  end

  def parameterize(string)
    Translit.convert(string, :english).downcase.gsub(/[^\w\s]/, '').strip.gsub(/\s+/, '-')
  end
end


task :data do
  rm_rf $poems_dst
  mkpath $poems_dst

  details = {}
  summary = {items: [], mapping: {}}

  PoemSources.all_sources do |src, index, tags, body, basename|
    date = Date.parse("2016-05-01") + index
    id = basename.to_i # poem_id_for_date(date)

    puts "processing ##{id}: #{src.basename}".yellow

    poem = OpenStruct.new
    poem.id = id
    poem.content = body.chomp
    poem.contentHtml = body.chop.lines.map do |line|
      line = line.chomp
      line = "&nbsp;" if line == ''
      "<p>#{line}</p>"
    end.join
    poem.author = tags['автор']
    poem.authorYears = tags['годы жизни']
    poem.year = tags['год'] ? tags['год'].to_i : nil
    poem.title = tags['название']
    poem.country = tags['страна']
    poem.translator = tags['перевод']
    poem.firstLine = body.lines.first.chomp
    poem.initialDate = date
    poem.slug = PoemSources.parameterize("#{id} #{poem.author} #{poem.title}")

    summary[:items] << {id: id, title: poem.title, author: poem.author}

    poem = poem.to_h
    poem.each_pair do |key, val|
      poem.delete(key) if val == nil || val == ''
    end

    details[id] = poem
    summary[:mapping][date] = id
  end

  details.each { |id, data| File.write $poems_dst / "#{id}.json", data.to_json }

  write_file $poems_dst / 'summary.json', summary.to_json
  write_file "site/data/poem_details.json", details.to_json
end

namespace :data do
  task :fix_encoding do
    rm_rf $utf8_poems_dir
    mkpath $utf8_poems_dir

    Pathname.glob($original_poems_dir / "*.txt").each do |path|
      sh "iconv -f CP1251 -t utf8 #{path.to_s.shellescape} > #{$utf8_poems_dir}/#{path.basename.to_s.shellescape}"
    end
  end

  task :randomize_and_number do
    start_index = 90
    Pathname.glob($utf8_poems_dir / "*.txt").to_a.map { |path| path }.shuffle.each_with_index do |path, index|
      cp path, $poems_src / "#{start_index + index + 1} #{path.basename}"
    end
  end

  task :randomize_and_number_original do
    rm_rf $shuffled_poems_dir
    mkpath $shuffled_poems_dir

    Pathname.glob($utf8_poems_dir / "*.txt").to_a.map { |path| path }.shuffle.each_with_index do |path, index|
      cp path, $poems_src / "#{index + 1} #{path.basename}"
    end
  end

  task :header_stats do
    headers = {}

    PoemSources.all_sources do |src, index, tags, body, basename|
      tags.each do |key, value|
        headers[key] ||= 0
        headers[key] += 1
      end
    end

    pp headers
  end
end

def write_file(path, data)
  File.write path, data
  puts "copy #{path}".magenta
end
