page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page '/index.html', layout: 'layout'
page '/*.html', layout: false

configure :build do
end

import_path(File.expand_path('bower_components/Framework7/dist/css', app.root)) { |path| "f7/#{path}" }
import_path(File.expand_path('bower_components/Framework7/dist/js', app.root)) { |path| "f7/#{path}" }
import_path(File.expand_path('bower_components/jquery/dist', app.root)) { |path| "jquery/#{path}" }
import_path(File.expand_path('bower_components/handlebars', app.root))
import_path(File.expand_path('tmp/poems', app.root))
import_path(File.expand_path('tmp/icons', app.root)) { |path| "images/#{path}" }
import_path(File.expand_path('www', app.root))

# activate :external_pipeline,
#   name: :handlebars,
#   command: "handlebars templates/*.hbs -f tmp/handlebars/templates.js -e hbs -k each -k if -k unless",
#   source: "tmp/handlebars",
#   latency: 1

activate :external_pipeline,
  name: :webpack,
  command: build? ? './node_modules/webpack/bin/webpack.js --bail' : './node_modules/webpack/bin/webpack.js --watch -d',
  source: "tmp/dist",
  latency: 1
