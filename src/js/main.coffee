require "framework7"
window.$$ = Dom7
window.$ = require "jquery"
window._ = require "lodash"
window.Handlebars = require "handlebars/runtime"
window.Handlebars.registerHelper require "./helpers"
require 'hammerjs'

require "../css/main.scss"
require "../about.html"
require "../demo.html"

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
