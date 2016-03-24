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
