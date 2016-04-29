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

poems = JSON.parse File.read "data/poem_details.json"
poems.each do |id, poem|
  proxy "/poems/#{poem['slug']}.html", "poem.html", locals: { poem_id: poem['id'], poem_title: poem['title'] }
end

helpers do
  def badge(type)
    url, alt = case type
      when 'appstore' then [data.site.appstore_url, "Загрузите в AppStore"]
      when 'playstore' then [data.site.playstore_url, "Загрузите на Google Play"]
    end
    link_to url, target: '_blank' do
      image_tag "badge-#{type}.png", width: 135, height: 40, alt: alt
    end
  end
end

ignore "/poem.html"
