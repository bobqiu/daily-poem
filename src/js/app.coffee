module.exports =
  templates: null
  render: (template, args...) ->
    @templates("./#{template}.hbs")(args...)

  # renderPoem: (id) ->
  #   @render 'poem', content: res, poemId: "poem-#{poemId}"
  #
