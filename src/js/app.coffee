monthNames = ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август' , 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь']

module.exports =
  render: (template, args...) ->
    @templates("./#{template}.hbs")(args...)

  renderPoemForCurrentDate: ->
    @renderPoemForDate Model.currentDate

  renderPoemForDate: (date) ->
    [poem, id] = Model.getPoemForDate(date)
    @render 'poem', content: poem, id: "poem-#{id}"

  init: ->
    @templates = require.context("../templates", true, /\.hbs$/)

    $('#sidebar').html @render('sidebar')
    $('#pages').html @render('home')

    # $.getJSON "poems/summary.json", (res) ->
    #   $('#poems-list-box').html App.render('poems', poems: res)

    Model.loadPoemsIntoMemory => @initPoemsView()
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
    $('.smm-swiper-slide.prev').html @renderPoemForDate Model.prevDate()
    $('.smm-swiper-slide.current').html @renderPoemForDate Model.currentDate
    $('.smm-swiper-slide.next').html @renderPoemForDate Model.nextDate()
    @mainView = new Poems.MainView
