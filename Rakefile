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


task(:serve) { sh "webpack-dev-server --content-base www --port 3000 --host 10.0.1.3" }
task(:serve_fs) { sh "ruby -run -e httpd www -p 3000" }
task(:build) { sh "webpack" }
task(:rebuild => %w(build data:parse)) {  sh "touch www/cordova.js" }
task(:clean) { sh "rm -rf www/*" }
task(:ios) { sh "cordova run ios" }


task clean_rebuild: %w(clean rebuild)
task prepare: %w(icons:build vendor:copy)
task c: :clean
task s: :serve
task sfs: :serve_fs
task p: :prepare
task b: :build
task rb: :rebuild
task crb: :clean_rebuild

namespace :appstore do
  task :pack do
    # is_release, build_app_name, file_version = update_config_xml $ios_next_version

    $app_name = 'DailyPoem'
    is_release = true
    file_version = "0.1.0"

    puts "Building a RELEASE version!" if is_release
    source_path = "#{Dir.pwd}/platforms/ios/build/device/#{$app_name}.app"
    target_path = "#{Dir.home}/desktop/#{$app_name}-#{file_version}.ipa"
    sh "cordova build --device #{'--release' if is_release} ios"
    sh %{/usr/bin/xcrun -sdk iphoneos PackageApplication "#{source_path}" -o "#{target_path}"}
  end
end
