namespace :icons do
  task :build do
    force = true
    colors = { main: '#0076ff', gray: '#cccccc' }

    convert = -> (src, dst, color) do
      sh "convert #{src} -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' #{dst}"
    end

    $icons_dst.mkpath
    Pathname.glob("#{$icons_src}/*.png") do |path|
      file = path.basename('.png')
      colors.each do |color_name, color|
        target = $icons_dst / "ai-#{file}-#{color_name}.png"
        convert.call(path, target, color) if !target.exist? or force
      end
    end
  end
end
