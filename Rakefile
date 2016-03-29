require 'pp'
require 'pathname'
require 'erb'
require 'json'
require 'date'

Dir.glob("tasks/*.rake") { |tasks| load tasks }

$icons_src = Pathname.new 'assets/png-icons'
$icons_dst = Pathname.new 'src/img'
$poems_src = Pathname.new 'assets/poems'
$poems_dst = Pathname.new 'www/poems'
$vendor_dir = Pathname.new 'www/vendor'
$app_name = 'DailyPoem'
$ios_emulator_target = ENV['target'] || "iPhone-6"
$ios_version = "0.3.0"


task(:serve) { sh "webpack-dev-server --content-base www --port 3000 --host 10.0.1.3" }
task(:serve_fs) { sh "ruby -run -e httpd www -p 3000" }
task(:build) { sh "webpack" }
task(:rebuild => %w(build data:parse)) {  sh "touch www/cordova.js" }
task(:clean) { sh "rm -rf www/*" }
task(:sim) { sh "cordova emulate ios --target='#{$ios_emulator_target}'" }
task(:ios_sims) { sh "platforms/ios/cordova/lib/list-emulator-images" }
task(:idev) { sh "cordova build ios --device; ios-deploy -b platforms/ios/build/device/#$app_name.ipa" }
task(:idev_run) { sh "cordova run ios --device" }
task('ios-release') { sh "cordova build ios --device --release" }


task clean_rebuild: %w(clean rebuild)
task prepare: %w(icons:build vendor:copy)
task c: :clean
task s: :serve
task sfs: :serve_fs
task p: :prepare
task b: [:build, :config]
task rb: :rebuild
task crb: :clean_rebuild
task conf: :config

task :config do
  build_number = Time.now.strftime('%m%d%H%M')
  # is_release = ENV['release'] == 'yes'
  # file_version = "#{version}.#{build_number}"
  # build_app_name = is_release ? $app_name : $app_name_dev
  # options = {version: version, build: build_number, name: build_app_name}
  # render_erb "config.xml.erb", "config.xml", options
  # [is_release, build_app_name, file_version]

  ios_portrait_screen_sizes = $ios_screen_sizes.keys.map { |size| size.split('x') }
  ios_landscrape_screen_sizes = ios_portrait_screen_sizes.map { |w, h| [h, w] }

  variables = {
    version: $ios_version,
    build_number: build_number,
    ios_screen_sizes: ios_portrait_screen_sizes + ios_landscrape_screen_sizes,
    plist_options: {
      UIStatusBarStyle: 'UIStatusBarStyleDefault',
      UIStatusBarHidden: true,
      UIViewControllerBasedStatusBarAppearance: false
    }
  }

  template = ERB.new File.read("config.xml.erb"), nil, '-'
  File.write "config.xml", template.result(OpenStruct.new(variables).instance_eval('binding'))
end

namespace :appstore do
  task :pack do
    # is_release, build_app_name, file_version = update_config_xml $ios_next_version
    is_release = true

    puts "Building a RELEASE version!" if is_release
    source_path = "#{Dir.pwd}/platforms/ios/build/device/#{$app_name}.ipa"
    target_path = "#{Dir.home}/desktop/#{$app_name}-#{$ios_version}.ipa"
    sh "cordova build --device #{'--release' if is_release} ios"
    # sh %{/usr/bin/xcrun -sdk iphoneos PackageApplication "#{source_path}" -o "#{target_path}"}
    sh "cp #{source_path} #{target_path}"
  end
end
