safe = (html) -> new Handlebars.SafeString(html)
render = (templatePath, args...) -> safe App.render(templatePath, args...)

module.exports =
  navbar: (options) ->
    {title} = options.hash
    render "shared/navbar", title: title
  page: (options) ->
    {pageId} = options.hash
    render "shared/page", id: pageId, content: options.fn(this)
