require "framework7"
window.$ = require "jquery"
window.Handlebars = require "handlebars/runtime"

require "../css/main.scss"
require "../about.html"
require "../demo.html"

# require.context("../../tmp/poems", true, /\.html$/)

window.templates = {}
templates[template] = require "../templates/#{template}.hbs" for template in ['poem', 'poems']

mainView = null

Router =
  go: (path) ->
    console.log "opening #{path}"
    location.hash = path

  route: ->
    hash = decodeURIComponent location.hash.slice(1)
    switch
      when hash == '' then return
      when hash.match /poems\//
        [_, poemId] = hash.split('/')
        $.get "poems/#{poemId}.html", (res) ->
          html = templates.poem(content: res, id: poemId)
          mainView.router.loadContent(html)
    return false
    # when hash in page_names
    #   load_page "#{hash}.html", null, ->
    #     $("#sidebar").panel('close')
    #     $('#page_content').enhanceWithin()
    #     $('body').trigger("app:page_loaded:#{hash}_view")
    # when hash.match(/page:/)
    #   page = hash.replace('page:', '')
    #   load_page "pages/#{page}.html", null, -> $("#sidebar").panel('close')

$ ->
  window.app = new Framework7 pushState: false #, ajaxLinks: 'ajax'
  window.$$ = Dom7

  $.getJSON "poems/summary.json", (res) ->
    $('#poems-list-box').html templates.poems(poems: res)

  mainView = app.addView '.view-main', dynamicNavbar: true
  window.appView = mainView

  app.onPageInit 'about', (page) ->
    console.log 'about'

  $$(document).on 'pageInit', (e) ->
    page = e.detail.page
    page.name
    console.log page.name, page

  $$(document).on 'pageInit', '.page[data-page="about"]', (e) ->

  $(document).on "click", 'a.action', (e) ->
    Router.go $(this).attr('href')

  $(window).on 'hashchange', Router.route

  Router.route()
