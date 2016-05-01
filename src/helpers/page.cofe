{render} = require './support'

module.exports = (options) ->
  {id} = options.hash
  render "shared/page", id: id, content: options.fn(this)
