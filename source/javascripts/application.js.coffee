document.addEventListener "DOMContentLoaded", ->
  window.app = new Framework7 pushState: yes
  window.$$ = Dom7

  $.getJSON "poems/summary.json", (res) ->
    $('#poems-list-box').html Handlebars.templates['poems_list'](poems: res)

  mainView = app.addView '.view-main', dynamicNavbar: true
  rightView = app.addView '.right-view'
  window.appView = mainView

  app.onPageInit 'about', (page) ->

  $$(document).on 'pageInit', (e) ->
    page = e.detail.page
    page.name

  $$(document).on 'pageInit', '.page[data-page="about"]', (e) ->

