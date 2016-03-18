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
  App.f7 = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
  App.mainView = App.f7.addView '.view-main', dynamicNavbar: true

window.Router = require "./router"

$ ->
  $('#sidebar').html App.render('sidebar')
  $('#pages').html App.render('home')

  $.getJSON "poems/summary.json", (res) ->
    $('#poems-list-box').html App.render('poems', poems: res)

  monthNames = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август' , 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь']
  calendarInline = App.f7.calendar
    container: '#calendar-inline-container', value: [new Date()], weekHeader: false,
    toolbarTemplate: App.render('shared/calendar_toolbar')
    onOpen: (p) ->
      console.log p
      $$('.calendar-custom-toolbar .center').text monthNames[p.currentMonth] + ', ' + p.currentYear
      $$('.calendar-custom-toolbar .left .link').on 'click', -> calendarInline.prevMonth()
      $$('.calendar-custom-toolbar .right .link').on 'click', -> calendarInline.nextMonth()
    onMonthYearChangeStart: (p) ->
      $$('.calendar-custom-toolbar .center').text(monthNames[p.currentMonth] + ', ' + p.currentYear)
