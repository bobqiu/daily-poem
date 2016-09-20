$original_poems_dir = Pathname.new "assets/poems-src-2"
$utf8_poems_dir = Pathname.new "assets/poems-utf-2"

require File.expand_path(__dir__) + '/../lib/poem_sources.rb'

task :data do
  rm_rf $poems_dst
  mkpath $poems_dst

  details = {}
  summary = {items: [], mapping: {}}
  gap = Date.parse("2016-07-29")..Date.parse("2016-08-09")

  date = Date.parse("2016-05-01") - 1

  PoemSources.all_sources do |src, index, tags, body, basename|
    date = gap.end if gap.include?(date)
    date = date + 1

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
