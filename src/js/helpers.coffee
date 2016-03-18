safe = (html) -> new Handlebars.SafeString(html)
# safeTemplate = (templatePath, args...) -> require("../templates/#{templatePath}.hbs")(args...)
safeTemplate = (templatePath, args...) -> safe AppTemplates("./#{templatePath}.hbs")(args...)

Handlebars.registerHelper
  navbar: (options) ->
    {title} = options.hash
    safeTemplate "shared/navbar", title: title
  page: (options) ->
    {pageId} = options.hash
    safeTemplate "shared/page", id: pageId, content: options.fn(this)
