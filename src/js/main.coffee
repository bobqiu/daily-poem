require "../css/main.scss"
require "../about.html"
require "../demo.html"

requireAll = (requireContext) -> requireContext.keys().forEach(requireContext)

window.Handlebars = require "handlebars/runtime"
require "./helpers"

window.Poems = {Views: {}, Services: {}, Models: {}}
window.Util = require "./util"

requireAll require.context("./models", true, /.(co|coffee)$/)
requireAll require.context("./services", true, /.(co|coffee)$/)

require "./app"
require "./router"

require './views/base'
requireAll require.context("./views", true, /.coffee$/)

main = ->
  # StatusBar?.backgroundColorByHexString("#ff9500")
  # StatusBar?.styleLightContent()

  window.Model = new Poems.Models.PoemApi
  window.PoemApi = Model
  window.App = new Poems.App
  window.Router = new Poems.Router

event = if cordova? then "deviceready" else "DOMContentLoaded"
document.addEventListener event, main, false
