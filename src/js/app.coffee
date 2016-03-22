class Poems.App
  render: (template, args...) ->
    @templates("./#{template}.hbs")(args...)

  renderPoemForDate: (date, next) ->
    Model.getPoemForDate date, (poem) =>
      context = $.extend {}, poem, domId: "poem-#{poem.id}", appDate: Util.formatMonthAndDay(date)
      html = @render 'poem', context
      next html

  renderPoemsForDate: (date) ->
    Model.setDate date
    @renderPoemForDate date, (html) => $('.smm-swiper-slide.current').html html
    @renderPoemForDate Util.prevDate(date), (html) => $('.smm-swiper-slide.prev').html html
    @renderPoemForDate Util.nextDate(date), (html) => $('.smm-swiper-slide.next').html html

  constructor: ->
    @templates = require.context("../templates", true, /\.hbs$/)

    $('#sidebar').html @render('sidebar')
    $('#pages').html @render('main')

    @f7app = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
    @f7view = @f7app.addView '.view-main', dynamicNavbar: true

    Model.loadMapping =>
      @renderPoemsForDate Util.today()
      @mainView = new Poems.MainView
      @initCalendar()

    $('.sidebar').on 'open', =>
      @sidebarCalendar.setValue [Model.currentDate]

  initCalendar: ->
    @sidebarCalendar = @f7app.calendar
      container: '#calendar-inline-container', value: [new Date()], weekHeader: false,
      toolbarTemplate: @render('shared/calendar_toolbar'),
      value: [Model.currentDate],
      disabled: [{from: Model.lastDate}, {to: Util.prevDate(Model.firstDate)}]
      onOpen: (p) =>
        $$('.calendar-custom-toolbar .center').text Util.t('months')[p.currentMonth] + ', ' + p.currentYear
        $$('.calendar-custom-toolbar .left .link').on 'click', => @sidebarCalendar.prevMonth()
        $$('.calendar-custom-toolbar .right .link').on 'click', => @sidebarCalendar.nextMonth()
      onMonthYearChangeStart: (p) =>
        $$('.calendar-custom-toolbar .center').text(Util.t('months')[p.currentMonth] + ', ' + p.currentYear)
        $$('.calendar-custom-toolbar .center').text(Util.t('months')[p.currentMonth] + ', ' + p.currentYear)
      onDayClick: (p, dayContainer, year, month, day) =>
        date = new Date(year, month, day)
        @renderPoemsForDate date
        @f7app.closePanel()

  router: ->
    @f7view.router
