class Poems.App
  constructor: ->
    $('#sidebar').html @render('sidebar')
    @loadTemplateOnMainPage 'main'
    @f7app = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
    @f7view = @f7app.addView '.view-main', dynamicNavbar: true

    Model.loadMapping =>
      Router.route()
      @initCalendar()

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

  openView: (viewName, args...) ->
    @currentView?.unmount()
    @currentView = null

    next = =>
      if viewName == 'Main'
        @currentView = new Poems.MainView

    @["render#{viewName}"](args..., next)

  renderMain: (identifier, next) ->
    @loadTemplateOnMainPage 'main'

    switch
      when identifier instanceof String and identifier.match(/\d{4}-\d{2}-\d{2}/)
        date = Date.parse(identifier)
        @renderPoemsForDate date, next
      when identifier instanceof String and identifier.match(/^\d+$/)
        id = Number(date)
        Model.getPoem id, (poem) =>
          @renderMain poem.date(), next
      when identifier instanceof Date
        @renderPoemsForDate identifier, next
      else
        @renderPoemsForDate Model.currentDate, next

  renderAbout: (next) ->
    version = null
    buildNumber = null
    p1 = cordova?.getAppVersion.getVersionNumber().then (value) -> version = value
    p2 = cordova?.getAppVersion.getBuildNumber().then (value) -> buildNumber = value
    Util.whenAllDone p1, p2, =>
      @loadTemplateOnMainPage 'about', versionText: "#{version} (#{buildNumber})"
      next && next()

  renderFavorites: (next) ->
    Model.getFavorites (poems) =>
      @loadTemplateOnMainPage 'favorites', poems: poems
      next && next()

  renderDeveloper: (next) ->
    data = firstDate: Util.dateString(Model.firstDate), lastDate: Util.dateString(Model.lastDate)
    @loadTemplateOnMainPage 'developer', data
    next && next()

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
        Router.go("poems/#{Util.dateString date}")
        # @openView 'Main', date
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
