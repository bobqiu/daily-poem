class Poems.App
  constructor: ->
    $('#sidebar').html @render('sidebar')
    @loadTemplateOnMainPage 'main'
    @f7app = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
    @f7view = @f7app.addView '.view-main', dynamicNavbar: true

    Model.loadMapping =>
      @renderPoemsForDate Util.today(), =>
        @mainView = new Poems.MainView
        @initCalendar()
        Router.route()

    $('.sidebar').on 'open', =>
      @sidebarCalendar.setValue [Model.currentDate]

  render: (template, args...) ->
    Util.render(template, args...)

  renderPoemForDate: (date, next) ->
    Model.getPoemForDate date, (poem) =>
      appDate = Util.formatMonthAndDay(date)
      if poem.last
        next @render 'tomorrow', appDate: appDate
      else
        context = $.extend {}, poem, domId: "poem-#{poem.id}", appDate: appDate, liked: poem.isLiked()
        html = @render 'poem', context
        next html

  renderPoemsForDate: (date, next) ->
    Model.setDate date
    count = 0
    done = -> ++count == 3 && next && next()
    @renderPoemForDate date, (html) => $('.smm-swiper-slide.current').html html; done()
    @renderPoemForDate Util.prevDate(date), (html) => $('.smm-swiper-slide.prev').html html; done()
    @renderPoemForDate Util.nextDate(date), (html) => $('.smm-swiper-slide.next').html html; done()

  renderMain: (date) ->
    date ?= Model.currentDate
    @loadTemplateOnMainPage 'main'
    @renderPoemsForDate date

  renderAbout: ->
    data = firstDate: Util.dateString(Model.firstDate), lastDate: Util.dateString(Model.lastDate)
    data.version = @version()
    @loadTemplateOnMainPage 'about', data

  renderFavorites: ->
    Model.getFavorites (poems) =>
      @loadTemplateOnMainPage 'favorites', poems: poems

  sharePoem: ->
    Model.getCurrentPoem (poem) ->
      if window.plugins?.socialsharing?
        window.plugins.socialsharing.share poem.content, poem.heading(), null, null

  likePoem: ->
    Model.currentPoem().like()

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
        @renderMain date
        @f7app.closePanel()

  router: ->
    @f7view.router

  load: (content) ->
    @router().loadContent content

  loadTemplate: (template, args...) ->
    @load @render template, args...

  loadTemplateOnMainPage: (template, args...) ->
    $('#pages').html @render template, args...

  version: ->
    '1.0.0'
