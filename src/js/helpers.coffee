{render} = require '../helpers/support'

module.exports =
  navbarBox: (options) ->
    render "shared/navbar_box", content: options.fn(this)
  assetUrl: (path) ->
    "bundle/#{path}"
  textUnless: (condition, text) ->
    unless condition then text else null
  textIf: (condition, text) ->
    if condition then text else null
