$brand_color = '#ff9800'
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


desc "generates coloured/gray/white icons out of the source black icons"
task :icons do
  colors = { main: $brand_color, gray: '#cccccc', light: '#ffffff' }

  convert = -> (src, dst, color) do
    sh "convert #{src} -channel RGB -fuzz 99% -fill '#{color}' -opaque '#000' #{dst}"
  end

  $icons_dst.mkpath
  Pathname.glob("#{$icons_src}/{ios,material}/*.png") do |path|
    theme = path.to_s.include?('ios/') ? 'ios' : 'material'
    file = path.basename('.png')
    colors.each do |color_name, color|
      target = $icons_dst / "#{theme}-#{file}-#{color_name}.png"
      convert.call(path, target, color) if !target.exist? or ENV['force']
    end
  end
end

desc "generates ios splash screens of all sizes out of one 2208x2208 image"
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

namespace :android do
  $base_app_icon = "assets/app-icons/AppIcon-1024.png"
  $base_launch_screen = "assets/app-icons/Default-Src.png"
  $android_res_dir = Pathname.new "assets/app-icons-android"
  $base_android_app_icon = $android_res_dir / "android-icon-1024.png"

  task resources: [:app_icons, :launch_screens, :playstore]

  task :mkdir do
    mkdir_p $android_res_dir
  end

  task base_appicon: :mkdir do
    size = 1024
    corners = 128
    background = "xc:none -fill white -draw 'roundRectangle 0,0 #{size},#{size} #{corners},#{corners}'"
    sh "convert -size #{size}x#{size} #{background} #{$base_app_icon} -compose SrcIn -composite #{$base_android_app_icon}"
  end

  task app_icons: :base_appicon do
    src = $base_android_app_icon
    sizes = %w(36 48 72 96 144 192)
    sizes.each do |size|
      dst = $android_res_dir / "android-icon-#{size}.png"
      sh "convert #{src} -resize #{size}x#{size} #{dst}"
    end
  end

  task launch_screens: :mkdir do
    src = $base_launch_screen
    sizes = %w(1920 1600 1280 800 480 320)
    sizes.each do |size1|
      size2 = size1.to_i * 9 / 16
      command = "convert #{src} -resize #{size1}x#{size1} -gravity center"
      sh "#{command} -crop #{size2}x#{size1}+0+0 #{$android_res_dir}/launch-portrait-#{size1}.png"
      sh "#{command} -crop #{size1}x#{size2}+0+0 #{$android_res_dir}/launch-landscape-#{size1}.png"
    end
  end

  task playstore: :mkdir do
    sh "convert #{$base_android_app_icon} -resize 512x512 #{$android_res_dir}/playstore-icon.png"
    sh "convert #{$base_launch_screen} -resize 1024x1024 -gravity center -crop 1024x500+0+0 #{$android_res_dir}/playstore-feature.jpg"
    sh "convert #{$base_launch_screen} -resize 180x180   -gravity center -crop 180x120+0+0  #{$android_res_dir}/playstore-promo.jpg"
    sh "convert #{$base_launch_screen} -resize 320x320   -gravity center -crop 320x180+0+0  #{$android_res_dir}/playstore-tv.jpg"
  end
end
