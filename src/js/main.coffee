require "framework7"
window.$$ = Dom7
window.$ = require "jquery"
window.Handlebars = require "handlebars/runtime"

require "../css/main.scss"
require "../about.html"
require "../demo.html"

window.Model = require "./model"
window.App = require "./app"
Handlebars.registerHelper require "./helpers"
window.Poems = {}
require './main_view'

$ ->
  window.App7 = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
  App.mainView = App7.addView '.view-main', dynamicNavbar: true

window.Router = require "./router"

$ ->
  Model.init()
  App.init()
