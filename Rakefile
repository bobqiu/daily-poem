require 'pp'
require 'pathname'
require 'erb'
require 'json'
require 'date'

task :s do
  # sh "bundle exec middleman serve -p 3000"
  sh "webpack-dev-server --content-base www --port 3000 --host 10.0.1.3"
end

def rake(task_name)
  puts "--- #{task_name}"
  Rake::Task[task_name].invoke
end

$icons_src = Pathname.new 'assets/png-icons'
$icons_dst = Pathname.new 'src/img'
$poems_src = Pathname.new 'assets/poems'
$poems_dst = Pathname.new 'www/poems'
$vendor_dir = Pathname.new 'www/vendor'

task :p do
  rake :icons
  rake 'data:parse'
  rake :copy_vendor_files
end

task :icons do
  rake 'icons:colorize'
end

namespace :icons do
  task :colorize do
    force = true
    color = '#0076ff'

    convert = -> (src, dst, color) do
      sh "convert #{src} -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' #{dst}"
    end

    $icons_dst.mkpath
    Pathname.glob("#{$icons_src}/*.png") do |path|
      file = path.basename('.png')
      target = $icons_dst / "ai-#{file}.png"
      convert.call(path, target, color) if !target.exist? or force
    end
  end
end

namespace :data do
  task :parse do
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
      # poem.content = body.chomp
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
end

task :copy_vendor_files do
  # $vendor_dir.mkpath
  # sh "cp -r node_modules/framework7/dist #{$vendor_dir}/framework7"
  sh "cp -r node_modules/framework7/dist/img/* src/img/"
end
