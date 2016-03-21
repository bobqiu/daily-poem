class Poems.App
  render: (template, args...) ->
    @templates("./#{template}.hbs")(args...)

  renderPoemForDate: (date, next) ->
    Model.getPoemForDate date, (poem) =>
      context = $.extend {}, poem, domId: "poem-#{poem.id}"
      html = @render 'poem', context
      next html

  constructor: ->
    @templates = require.context("../templates", true, /\.hbs$/)

    $('#sidebar').html @render('sidebar')
    $('#pages').html @render('home')

    @f7 = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
    @f7View = @f7.addView '.view-main', dynamicNavbar: true

    Model.loadMapping =>
      @initPoemsView()
      @initCalendar()

  initCalendar: ->
    @sidebarCalendar = @f7.calendar
      container: '#calendar-inline-container', value: [new Date()], weekHeader: false,
      toolbarTemplate: @render('shared/calendar_toolbar')
      onOpen: (p) =>
        $$('.calendar-custom-toolbar .center').text monthNames[p.currentMonth] + ', ' + p.currentYear
        $$('.calendar-custom-toolbar .left .link').on 'click', => @sidebarCalendar.prevMonth()
        $$('.calendar-custom-toolbar .right .link').on 'click', => @sidebarCalendar.nextMonth()
      onMonthYearChangeStart: (p) =>
        $$('.calendar-custom-toolbar .center').text(monthNames[p.currentMonth] + ', ' + p.currentYear)

  initPoemsView: ->
    @renderPoemForDate Model.prevDate(), (html) => $('.smm-swiper-slide.prev').html html
    @renderPoemForDate Model.currentDate, (html) => $('.smm-swiper-slide.current').html html
    @renderPoemForDate Model.nextDate(), (html) => $('.smm-swiper-slide.next').html html
    @mainView = new Poems.MainView

  monthNames = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август' , 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь']

  router: ->
    @f7View.router
