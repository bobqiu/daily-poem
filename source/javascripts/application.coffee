require "framework7"
window.$ = require "jquery"
window.Handlebars = require "handlebars/runtime"

require "../stylesheets/application.scss"
require "../about.html"
require "../demo.html"
require "../index.html"

# require.context("../../tmp/poems", true, /\.html$/)

window.templates = {}
templates.poemsList = require "../templates/poems_list.hbs"

document.addEventListener "DOMContentLoaded", ->
  window.app = new Framework7 pushState: yes
  window.$$ = Dom7

  $.getJSON "../poems/summary.json", (res) ->
    $('#poems-list-box').html templates.poemsList(poems: res)

  mainView = app.addView '.view-main', dynamicNavbar: true
  window.appView = mainView

  app.onPageInit 'about', (page) ->

  $$(document).on 'pageInit', (e) ->
    page = e.detail.page
    page.name

  $$(document).on 'pageInit', '.page[data-page="about"]', (e) ->
