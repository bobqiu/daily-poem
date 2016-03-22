safe = (html) -> new Handlebars.SafeString(html)
render = (templatePath, args...) -> safe App.render(templatePath, args...)

module.exports =
  navbar: (options) ->
    {title} = options.hash
    render "shared/navbar", title: title
  page: (options) ->
    {id} = options.hash
    render "shared/page", id: id, content: options.fn(this)
  assetUrl: (path) ->
    "#{path}"
