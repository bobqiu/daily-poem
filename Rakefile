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
$brand_color = '#ff9800'
$status_bar_color = '#EF6C00'
$brand_color_gradient = '#FF7500'
$ios_version = "1.1"
$ios_emulator_target = "iPhone-6"
# $ios_emulator_target = "iPhone-6, 8.1"
$android_key_path = "#{Dir.home}/code/_etc/my-release-key.keystore"
