module.exports =
  templates: null
  render: (template, args...) ->
    @templates("./#{template}.hbs")(args...)
