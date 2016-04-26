require "../css/main.scss"
require "../about.html"

console.xdebug ?= ->

requireAll = (requireContext) -> requireContext.keys().forEach(requireContext)

window.Handlebars = require "handlebars/runtime"
require "./helpers"

window.Poems = {Views: {}, Services: {}, Models: {}}
window.Util = require "./util"

requireAll require.context("./lib", true, /.(co|coffee)$/)
requireAll require.context("./models", true, /.(co|coffee)$/)
requireAll require.context("./services", true, /.(co|coffee)$/)

require "./app"
require "./router"

require './views/base'
requireAll require.context("./views", true, /.coffee$/)

main = ->
  # StatusBar?.backgroundColorByHexString("#ff9500")
  # StatusBar?.styleLightContent()

  window.PoemApi = new Poems.Models.PoemApi
  window.Model = PoemApi
  window.App = new Poems.App
  window.Router = new Poems.Router

event = if cordova? then "deviceready" else "DOMContentLoaded"
document.addEventListener event, main, false
