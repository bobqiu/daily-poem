page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page '/index.html', layout: 'layout'
page '/*.html', layout: false

configure :build do
end

import_path(File.expand_path('bower_components/Framework7/dist/css', app.root)) { |path| "f7/#{path}" }
import_path(File.expand_path('bower_components/Framework7/dist/js', app.root)) { |path| "f7/#{path}" }
