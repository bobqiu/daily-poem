task(:server) { sh "webpack-dev-server --content-base www --port 3000 --host 10.0.1.2" }
task(:fsserver) { sh "ruby -run -e httpd www -p 3000" }
task(:watch) { sh "webpack -w" }

task(:ios_build) { sh "cordova build ios" }
task(:ios) { sh "cordova emulate ios --target='#{ENV['target'] || $ios_emulator_target}'" }
task(:ios_device) { sh "cordova build ios --device; ios-deploy -b platforms/ios/build/device/#$app_name.ipa" }
task(:ios_release) { sh "cordova build ios --device --release" }
task(:ios_simulators) { sh "platforms/ios/cordova/lib/list-emulator-images" }
task(:xcode) {   sh "open platforms/ios/#$app_name.xcodeproj" }

task(:android) { sh "cordova run android" }
task(:android_release) { sh "cordova build android --device --release" }
task(:android_emulators) { sh "platforms/android/cordova/lib/list-emulator-images" }

task p: "pack:build"
task pc: "pack:rebuild"
namespace :pack do
  task(:clean) { sh "rm -rf www/*" }

  task files: :data do
    touch "www/cordova.js"
    touch "www/favicon.ico"
    touch "www/framework7.js.map"
    touch "www/app.css.map"
  end

  task(:ios) { sh "THEME=ios webpack" }
  task(:android) { sh "THEME=material webpack" }
  task(:android_release) { sh "THEME=material RELEASE=YES webpack" }
  task(:android_release_min) { sh "THEME=material RELEASE=YES webpack -p" }

  task rebuild: [:clean, :files, :build]
end
# rake pack:clean pack:files pack:android_release

task prepare_src: %w(icons vendor:copy)
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
    brand_color: $brand_color,
    status_bar_color: $status_bar_color,
    plist_options: {
      UIStatusBarStyle: 'UIStatusBarStyleDefault',
      UIStatusBarHidden: true,
      UIViewControllerBasedStatusBarAppearance: false,
      ITSAppUsesNonExemptEncryption: false
    }
  }

  template = ERB.new File.read("config.xml.erb"), nil, '-'
  File.write "config.xml", template.result(OpenStruct.new(variables).instance_eval('binding'))

  appinfo = {
    version: $ios_version,
    build: build_number
  }
  File.write "src/data.json", appinfo.to_json
end

task rebuild:  [:conf, 'pack:clean', 'pack:files', :pack, :device]
task appstore: [:conf, 'pack:clean', 'pack:files', :pack_release, :ios_release, :check_release]

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

task :playstore do
  # run: keytool -genkey -v -keystore my-release-key.keystore -alias name.sokurenko -keyalg RSA -keysize 2048 -validity 10000
  apk = "platforms/android/build/outputs/apk/android-release-unsigned.apk"
  target = "#{Dir.home}/desktop/#{$app_name}-#{$ios_version}.apk"
  sh "cordova build android --release --device"
  sh "jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore #{$android_key_path} -storepass $PS_KEYSTORE_PWD #{apk} name.sokurenko"
  rm_rf target
  sh "~/Library/Android/sdk/build-tools/23.0.1/zipalign -v 4 #{apk} #{target}"
end
