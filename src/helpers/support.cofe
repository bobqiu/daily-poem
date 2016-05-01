safe = (html) ->
  new Handlebars.SafeString(html)

render = (templatePath, args...) ->
  safe Util.render(templatePath, args...)

module.exports = {safe, render}
