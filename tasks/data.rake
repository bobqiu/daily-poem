def poem_id_for_date(date)
  date.strftime("%Y%m%d").to_i
end

task :data do
  $poems_dst.mkpath

  details = {}
  summary = {items: [], mapping: {}}

  Pathname.glob("#{$poems_src}/*.txt").each_with_index do |src, index|
    basename = File.basename(src, '.txt')
    text = File.read(src)
    header, body = text.split("---\n", 2)
    date = Date.today - 5 + index
    id = poem_id_for_date(date) # basename.to_i


    tag_lines = header.split("\n")
    tags = tag_lines.each_with_object({}) do |line, map|
      name, value = line.split(': ')
      map[name] = value
    end

    poem = OpenStruct.new
    poem.id = id
    poem.content = body.chomp
    poem.contentHtml = body.chop.lines.map do |line|
      line = line.chomp
      line = "&nbsp;" if line == ''
      "<p>#{line}</p>"
    end.join
    poem.author = tags['автор']
    poem.year = tags['год'] ? tags['год'].to_i : nil
    poem.source = tags['источник']
    poem.title = tags['название']
    poem.firstLine = body.lines.first.chomp

    # template = ERB.new(File.read('other/poem.erb'), nil, '-')
    # template.result(binding)

    summary[:items] << {id: id, title: poem.title, author: poem.author}
    details[id] = poem.to_h
    summary[:mapping][date] = id
  end

  # summary[:mapping] = (Date.today - 5 .. Date.today + 5).inject({}) { |map, date| map[date] = map.size + 1; map }

  details.each { |id, data| File.write $poems_dst / "#{id}.json", data.to_json }
  File.write $poems_dst / 'summary.json', summary.to_json

  File.write "site/data/poem_details.json", details.to_json
  File.write "site/data/poem_summary.json", summary.to_json
end
