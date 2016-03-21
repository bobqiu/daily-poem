monthNames = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август' , 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь']

module.exports =
  render: (template, args...) ->
    @templates("./#{template}.hbs")(args...)

  # renderPoemForCurrentDate: ->
  #   @renderPoemForDate Model.currentDate

  renderPoemForDate: (date, next) ->
    Model.getPoemForDate date, (poem) =>
      context = $.extend {}, poem, domId: "poem-#{poem.id}"
      html = @render 'poem', context
      next html

  init: ->
    @templates = require.context("../templates", true, /\.hbs$/)

    $('#sidebar').html @render('sidebar')
    $('#pages').html @render('home')

    # $.getJSON "poems/summary.json", (res) ->
    #   $('#poems-list-box').html App.render('poems', poems: res)

    # Model.loadPoemsIntoMemory => @initPoemsView()
    @initPoemsView()
    @initCalendar()

  initCalendar: ->
    @sidebarCalendar = App7.calendar
      container: '#calendar-inline-container', value: [new Date()], weekHeader: false,
      toolbarTemplate: @render('shared/calendar_toolbar')
      onOpen: (p) ->
        $$('.calendar-custom-toolbar .center').text monthNames[p.currentMonth] + ', ' + p.currentYear
        $$('.calendar-custom-toolbar .left .link').on 'click', -> calendarInline.prevMonth()
        $$('.calendar-custom-toolbar .right .link').on 'click', -> calendarInline.nextMonth()
      onMonthYearChangeStart: (p) ->
        $$('.calendar-custom-toolbar .center').text(monthNames[p.currentMonth] + ', ' + p.currentYear)

  initPoemsView: ->
    @renderPoemForDate Model.prevDate(), (html) => $('.smm-swiper-slide.prev').html html
    @renderPoemForDate Model.currentDate, (html) => $('.smm-swiper-slide.current').html html
    @renderPoemForDate Model.nextDate(), (html) => $('.smm-swiper-slide.next').html html
    @mainView = new Poems.MainView
