require "../css/main.scss"
require "../about.html"
require "../demo.html"

requireAll = (requireContext) -> requireContext.keys().forEach(requireContext)

window.Handlebars = require "handlebars/runtime"
require "./helpers"

window.Poems = {Views: {}, Services: {}}
window.Util = require "./util"
require "./model"
require "./app"
require "./router"
require './services/notifications'

require './views/base'
requireAll require.context("./views", true, /.coffee$/)
requireAll require.context("./services", true, /.coffee$/)


main = ->
  # StatusBar?.backgroundColorByHexString("#ff9500")
  # StatusBar?.styleLightContent()

  window.Model = new Poems.Model
  window.App = new Poems.App
  window.Router = new Poems.Router

event = if cordova? then "deviceready" else "DOMContentLoaded"
document.addEventListener event, main, false
