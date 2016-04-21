{render} = require './support'

module.exports = (options) ->
  {title} = options.hash
  render "shared/navbar", title: title
