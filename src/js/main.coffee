require "framework7"
window.$$ = Dom7
window.$ = require "jquery"
window.Handlebars = require "handlebars/runtime"
window.Handlebars.registerHelper require "./helpers"

require "../css/main.scss"
require "../about.html"
require "../demo.html"

window.Poems = {}
require "./model"
require "./app"
require "./router"
require './main_view'

$ ->
  window.App7 = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
  window.Model = new Poems.Model
  window.App = new Poems.App
  window.App.mainView = App7.addView '.view-main', dynamicNavbar: true
  window.Router = new Poems.Router
