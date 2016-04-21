task :data do
  $poems_dst.mkpath

  summary = {items: []}

  Pathname.glob("#{$poems_src}/*.txt") do |src|
    basename = File.basename(src, '.txt')
    text = File.read(src)
    header, body = text.split("---\n", 2)

    tag_lines = header.split("\n")
    tags = tag_lines.each_with_object({}) do |line, map|
      name, value = line.split(': ')
      map[name] = value
    end

    poem = OpenStruct.new
    poem.id = basename.to_i
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

    File.write $poems_dst / "#{basename}.json", poem.to_h.to_json
    summary[:items] << {id: basename.to_i, title: poem.title, author: poem.author}
  end

  summary[:mapping] = (Date.today - 5 .. Date.today + 5).inject({}) { |map, date| map[date] = map.size + 1; map }

  File.write $poems_dst / 'summary.json', summary.to_json
end
