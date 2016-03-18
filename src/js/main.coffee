require "framework7"
window.$$ = Dom7
window.$ = require "jquery"
window.Handlebars = require "handlebars/runtime"

require "../css/main.scss"
require "../about.html"
require "../demo.html"

window.AppTemplates = require.context("../templates", true, /\.hbs$/)

window.App = require "./app"
require "./helpers"

for template in ['poem', 'poems', 'favorites']
  App.templates[template] = require "../templates/#{template}.hbs"

$ ->
  App.f7 = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
  App.mainView = App.f7.addView '.view-main', dynamicNavbar: true

window.Router = require "./router"

$ ->
  $.getJSON "poems/summary.json", (res) ->
    $('#poems-list-box').html App.templates.poems(poems: res)
