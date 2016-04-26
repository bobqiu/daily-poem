require "../css/main.scss"
require "../about.html"

console.xdebug ?= ->

requireAll = (requireContext) -> requireContext.keys().forEach(requireContext)

window.Handlebars = require "handlebars/runtime"
require "./helpers"

window.AP = {}
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

  window.PoemApi = new AP.PoemApi
  window.Model = PoemApi
  window.App = new AP.App
  window.Router = new AP.Router

event = if cordova? then "deviceready" else "DOMContentLoaded"
document.addEventListener event, main, false
