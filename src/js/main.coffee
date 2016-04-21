require "../css/main.scss"
require "../about.html"
require "../demo.html"

window.Handlebars = require "handlebars/runtime"
require "./helpers"

window.Poems = {}
window.Util = require "./util"
require "./model"
require "./app"
require "./router"
require './main-view'

main = ->
  # StatusBar?.backgroundColorByHexString("#ff9500")
  # StatusBar?.styleLightContent()

  window.Model = new Poems.Model
  window.App = new Poems.App
  window.Router = new Poems.Router

event = if cordova? then "deviceready" else "DOMContentLoaded"
document.addEventListener event, main, false
