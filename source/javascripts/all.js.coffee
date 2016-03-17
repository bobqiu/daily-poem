document.addEventListener "DOMContentLoaded", ->
  window.app = new Framework7
  window.$$ = Dom7

  mainView = app.addView '.view-main', dynamicNavbar: true
  rightView = app.addView '.right-view'
  window.appView = mainView

  app.onPageInit 'about', (page) ->

  $$(document).on 'pageInit', (e) ->
    page = e.detail.page
    page.name

  $$(document).on 'pageInit', '.page[data-page="about"]', (e) ->
