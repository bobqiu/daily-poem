require "framework7"
window.$$ = Dom7
window.$ = require "jquery"
window.Handlebars = require "handlebars/runtime"

require "../css/main.scss"
require "../about.html"
require "../demo.html"

window.App = require "./app"
Handlebars.registerHelper require "./helpers"
App.templates = require.context("../templates", true, /\.hbs$/)

$ ->
  window.App7 = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
  App.mainView = App7.addView '.view-main', dynamicNavbar: true

window.Router = require "./router"

$ ->
  $('#sidebar').html App.render('sidebar')
  $('#pages').html App.render('home')

  $.getJSON "poems/summary.json", (res) ->
    $('#poems-list-box').html App.render('poems', poems: res)

  monthNames = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август' , 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь']
  calendarInline = App7.calendar
    container: '#calendar-inline-container', value: [new Date()], weekHeader: false,
    toolbarTemplate: App.render('shared/calendar_toolbar')
    onOpen: (p) ->
      $$('.calendar-custom-toolbar .center').text monthNames[p.currentMonth] + ', ' + p.currentYear
      $$('.calendar-custom-toolbar .left .link').on 'click', -> calendarInline.prevMonth()
      $$('.calendar-custom-toolbar .right .link').on 'click', -> calendarInline.nextMonth()
    onMonthYearChangeStart: (p) ->
      $$('.calendar-custom-toolbar .center').text(monthNames[p.currentMonth] + ', ' + p.currentYear)

  index = 10

  App.poems = []
  requests = []
  currentPoemIndex = 2
  for i in [1..6]
    requests.push $.get("poems/#{i}.html").then (res) ->
      App.poems.push res

  Promise.all(requests).then ->
    $('.swiper-slide-prev').html App.render 'poem', content: App.poems[1], id: 1
    $('.swiper-slide-active').html App.render 'poem', content: App.poems[2], id: 2
    $('.swiper-slide-next').html App.render 'poem', content: App.poems[3], id: 3

  App.swiper = App7.swiper '.swiper-container',
    speed: 400, spaceBetween: 100, initialSlide: 1
    onSlideNextEnd: (s) ->
      s.removeSlide(0) if s.slides.length is 2
      # s.removeSlide(s.activeIndex - 4) if s.slides.length > 5
      currentPoemIndex++
      html = App.render 'poem', content: App.poems[currentPoemIndex], id: currentPoemIndex
      s.appendSlide "<div class='swiper-slide'>#{html}</div>"
    onSlidePrevEnd: (s) ->
      s.removeSlide(2) if s.activeIndex is 0
      # s.removeSlide(s.activeIndex + 4) if s.slides.length > 5
      currentPoemIndex--
      html = App.render 'poem', content: App.poems[currentPoemIndex], id: currentPoemIndex
      s.prependSlide "<div class='swiper-slide'>#{html}</div>"
  App.swiper.removeSlide(3)

