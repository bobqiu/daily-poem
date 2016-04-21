$brand_color = '#ff9500'
# $brand_color = '#007aff'
$brand_color_gradient = '#FF7500'

$ios_screen_sizes = {
  "320x480"   => 1,
  "640x960"   => 2,
  "640x1136"  => 2,
  "750x1334"  => 2,
  "1242x2208" => 3,
  "1024x768"  => 1,
  "1536x2048" => 2,
}


task :icons do
  colors = { main: $brand_color, gray: '#cccccc', light: '#ffffff' }

  convert = -> (src, dst, color) do
    sh "convert #{src} -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' #{dst}"
  end

  $icons_dst.mkpath
  Pathname.glob("#{$icons_src}/*.png") do |path|
    file = path.basename('.png')
    colors.each do |color_name, color|
      target = $icons_dst / "ai-#{file}-#{color_name}.png"
      convert.call(path, target, color) if !target.exist? or ENV['force']
    end
  end
end

task :splash do
  src = "assets/app-icons/Default-Src.png"

  def convert_size(src, w, h)
    size = "#{w}x#{h}"
    dst = "assets/launch-screens/Default-#{size}.png"
    sh "convert #{src} -resize #{size}^ -gravity center -extent #{size} -quality 100 #{dst}"
  end

  $ios_screen_sizes.each do |size, density|
    w, h = size.split('x').map(&:to_i)
    convert_size src, w, h
    convert_size src, h, w
  end
end

task :frames do
  Dir.chdir "assets/screenshots"
  sh "bundle exec frameit silver"
end
