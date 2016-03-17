require 'pp'
require 'pathname'
require 'erb'
require 'json'

task :s do
  # sh "bundle exec middleman serve -p 3000"
  sh "webpack-dev-server --content-base www --port 3000"
end

$icons_src = Pathname.new 'assets/png-icons'
$icons_dst = Pathname.new 'tmp/icons'
$poems_src = Pathname.new 'poems'
$poems_dst = Pathname.new 'tmp/poems'

task :icons do
  Rake::Task['icons:colorize'].invoke
  # sh "icons-colorize-all #{$icons_src_dir} #{$icons_dst_dir} -color #0076ff -force"
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
      target = $icons_dst / "#{file}.png"
      convert.call(path, target, color) if !target.exist? or force
    end
  end
end

namespace :data do
  task :parse do
    $poems_dst.mkpath

    summary = []

    Pathname.glob("#{$poems_src}/*.txt") do |src|
      text = File.read(src)
      header, body = text.split("---\n", 2)

      tag_lines = header.split("\n")
      tags = tag_lines.each_with_object({}) do |line, map|
        name, value = line.split(': ')
        map[name] = value
      end

      basename = File.basename(src, '.txt')
      dst = $poems_dst / "#{basename}.html"
      template = ERB.new(File.read('other/poem.erb'), nil, '-')

      @content = body
      @author = tags['автор']
      @date = tags['дата']
      @source = tags['источник']
      @title = body.lines.first

      File.write dst, template.result(binding)

      summary << {id: basename.to_i, title: @title, author: @author}

      File.write $poems_dst / 'summary.json', summary.to_json
    end
  end
end
