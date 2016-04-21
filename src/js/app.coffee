class Poems.App
  constructor: ->
    $('#sidebar').html @render('sidebar')
    @loadTemplateOnMainPage 'pages/main'
    @f7app = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
    @f7view = @f7app.addView '.view-main', dynamicNavbar: true

    $(document).click (e) =>
      [x, y] = [e.pageX, e.pageY]
      # testMode = yes
      # if testMode # and y < 100
      #   @performNextTestAction()

    Model.loadMapping =>
      Router.route()

    $('.sidebar').on 'open', =>

    navigator.splashscreen?.hide()
    setTimeout =>
      StatusBar?.show()
    , 500

  render: (template, args...) ->
    Util.render(template, args...)

  renderPoemForDate: (date, next) ->
    Model.getPoemForDate date, (poem) =>
      appDate = Util.formatMonthAndDay(date)
      if Util.dateString(date) > Util.dateString(Model.lastAllowedDate())
        next @render 'tomorrow', appDate: appDate
      else if poem.last
        next ""
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
    @loadTemplateOnMainPage 'pages/main'

    renderDate = (date) =>
      @renderPoemsForDate date, next

    switch
      when typeof identifier is 'string' and identifier.match(/\d{4}-\d{2}-\d{2}/)
        date = new Date(identifier)
        renderDate date
      when typeof identifier is 'string' and identifier.match(/^\d+$/)
        id = Number(identifier)
        console.log id, identifier
        Model.getPoem id, (poem) =>
          @renderMain poem.date(), next
      when identifier instanceof Date
        renderDate identifier
      else
        renderDate Model.currentDate

  renderAbout: (next) ->
    version = null
    buildNumber = null
    p1 = cordova?.getAppVersion.getVersionNumber().then (value) -> version = value
    p2 = cordova?.getAppVersion.getVersionCode().then (value) -> buildNumber = value
    Promise.all([p1, p2]).then =>
      @loadTemplateOnMainPage 'pages/about', versionText: "#{version} (#{buildNumber})"
      $('#dmitry-avatar').click =>
        @developerClickCount ?= 0
        @developerClickCount += 1
        if @developerClickCount % 4 is 0
          $('#developer-tab').toggle()
      next?()

  renderFavorites: (next) ->
    Model.getFavorites (poems) =>
      @loadTemplateOnMainPage 'pages/favorites', poems: poems
      next?()

  renderDeveloper: (next) ->
    data = firstDate: Util.dateString(Model.firstDate), lastDate: Util.dateString(Model.lastDate)
    @loadTemplateOnMainPage 'pages/developer', data
    next?()

  renderCalendar: (next) ->
    @loadTemplateOnMainPage 'pages/calendar'

    calendar = @f7app.calendar
      container: '#calendar-inline-container',
      weekHeader: false,
      toolbarTemplate: @render('shared/calendar-toolbar')
      value: [Model.currentDate]
      disabled: [{from: Model.lastAllowedDate()}, {to: Util.prevDate(Model.firstDate)}]
      onOpen: (p) =>
        $('.calendar-custom-toolbar .center').text Util.t('months')[p.currentMonth] + ', ' + p.currentYear
        $('.calendar-custom-toolbar .left .link').click => calendar.prevMonth()
        $('.calendar-custom-toolbar .right .link').click => calendar.nextMonth()
      onMonthYearChangeStart: (p) =>
        $('.calendar-custom-toolbar .center').text(Util.t('months')[p.currentMonth] + ', ' + p.currentYear)
        $('.calendar-custom-toolbar .center').text(Util.t('months')[p.currentMonth] + ', ' + p.currentYear)
      onDayClick: (p, dayContainer, year, month, day) =>
        date = new Date(year, month, day)
        Router.go("poems/#{Util.dateString date}")
        @f7app.closePanel()

    next?()

  sharePoem: ->
    Model.getCurrentPoem (poem) ->
      if window.plugins?.socialsharing?
        window.plugins.socialsharing.share poem.content, poem.heading(), null, null

  likePoem: ->
    Model.currentPoem().like()

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

  performNextTestAction: ->
    @actions ?= [
      -> Router.go("poems/6")
      => @f7app.openPanel('left')
      =>
        @f7app.closePanel()
        Router.go("favorites")
    ]
    @lastActionIndex ?= 0

    action = @actions[@lastActionIndex++]
    action && action()
