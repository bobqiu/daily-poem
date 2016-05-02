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
