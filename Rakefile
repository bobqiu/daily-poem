require 'pp'
require 'pathname'
require 'erb'
require 'json'
require 'date'
require 'translit'
require 'colorize'

Dir.glob("tasks/*.rake") { |tasks| load tasks }

$icons_src = Pathname.new 'assets/png-icons'
$icons_dst = Pathname.new 'src/img'
$poems_src = Pathname.new 'assets/poems'
$poems_dst = Pathname.new 'www/poems'
$vendor_dir = Pathname.new 'www/vendor'
$app_name = 'DailyPoem'
$ios_emulator_target = ENV['target'] || "iPhone-6"
$ios_version = "1.0"


task(:server) { sh "webpack-dev-server --content-base www --port 3000 --host 10.0.1.3" }
task(:server_www) { sh "ruby -run -e httpd www -p 3000" }
task(:www) { sh "webpack" }
task(:www_release) { sh "RELEASE=YES webpack -p" }
task(:watch) { sh "webpack -w" }
task(:clean) { sh "rm -rf www/*" }
task(:build) { sh "cordova build ios" }
task(:simulator) { sh "cordova emulate ios --target='#{$ios_emulator_target}'" }
task(:device) { sh "cordova build ios --device; ios-deploy -b platforms/ios/build/device/#$app_name.ipa" }

task(:ios_release) { sh "cordova build ios --device --release" }
task(:xcode) {   sh "open platforms/ios/#$app_name.xcodeproj" }
task(:ios_simulators) { sh "platforms/ios/cordova/lib/list-emulator-images" }

task prepare: %w(data) do
  sh "touch www/cordova.js"
  sh "touch www/favicon.ico"
end

task prepare_all: %w(icons:build vendor:copy data)
task s: :server
task dev: :device
task sim: :simulator


task :conf do
  build_number = Time.now.strftime('%y%m%d.%H%M')
  ios_portrait_screen_sizes = $ios_screen_sizes.keys.map { |size| size.split('x') }
  ios_landscrape_screen_sizes = ios_portrait_screen_sizes.map { |w, h| [h, w] }

  variables = {
    version: $ios_version,
    build_number: build_number,
    ios_screen_sizes: ios_portrait_screen_sizes + ios_landscrape_screen_sizes,
    plist_options: {
      UIStatusBarStyle: 'UIStatusBarStyleDefault',
      UIStatusBarHidden: true,
      UIViewControllerBasedStatusBarAppearance: false,
      ITSAppUsesNonExemptEncryption: false
    }
  }

  template = ERB.new File.read("config.xml.erb"), nil, '-'
  File.write "config.xml", template.result(OpenStruct.new(variables).instance_eval('binding'))
end

task rebuild:  [:conf, :clean, :prepare, :www, :device]
task appstore: [:conf, :clean, :prepare, :www_release, :ios_release, :check_release]

#  do
#   is_release = true
#   source_path = "#{Dir.pwd}/platforms/ios/build/device/#{$app_name}.ipa"
#   target_path = "#{Dir.home}/desktop/#{$app_name}-#{$ios_version}.ipa"
#   sh "cordova build --device #{'--release' if is_release} ios"
#   # sh %{/usr/bin/xcrun -sdk iphoneos PackageApplication "#{source_path}" -o "#{target_path}"}
#   sh "cp #{source_path} #{target_path}"
# end

task(:deliver) { sh "BINARY=YES deliver" }

task :reinstall_customizations do
  sh "cordova plugin rm cordova-plugin-app-customization"
  sh "cordova plugin add assets/plugins/cordova-plugin-app-customization"
end

task :check_release do
  checks = OpenStruct.new
  checks.specs = File.exist?("www/spec.js")
  checks.devserver = File.read("www/index.html").include?("http://10.0.1.3:3000")
  checks.non_minified = File.read("www/app.js").include?("webpackBootstrap")
  checks.each_pair do |key, value|
    puts "Release invariant failed: #{key.to_s.upcase}".red if value
  end
end

task :colors do
  puts String.color_samples
  p String.colors
  p String.modes
end
