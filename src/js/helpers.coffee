safe = (html) -> new Handlebars.SafeString(html)
render = (templatePath, args...) -> safe Util.render(templatePath, args...)

module.exports =
  navbar: (options) ->
    {title} = options.hash
    render "shared/navbar", title: title
  page: (options) ->
    {id} = options.hash
    render "shared/page", id: id, content: options.fn(this)
  navbarBox: (options) ->
    render "shared/navbar_box", content: options.fn(this)
  assetUrl: (path) ->
    "bundle/#{path}"
  textUnless: (condition, text) ->
    unless condition then text else null
  textIf: (condition, text) ->
    if condition then text else null
