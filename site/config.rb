activate :sprockets
set :source, 'src'
set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

configure :development do
  # activate :livereload
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :gzip

  # activate :relative_assets
  # set :http_prefix, "/Content/images/"
end
