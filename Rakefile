require 'pathname'

task :s do
  sh "bundle exec middleman serve -p 3000"
end

$icons_src_dir = Pathname.new 'assets/png-icons'
$icons_dst_dir = Pathname.new 'source/images/icons'

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

    $icons_dst_dir.mkpath
    Pathname.glob("#{$icons_src_dir}/*.png") do |path|
      file = path.basename('.png')
      target = $icons_dst_dir / "#{file}.png"
      convert.call(path, target, color) if !target.exist? or force
    end
  end
end
