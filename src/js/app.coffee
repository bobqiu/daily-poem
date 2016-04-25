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
      setTimeout =>
        @notifications = new Poems.Services.Notifications
        @notifications.setReminders()
      , 100

    $('.sidebar').on 'open', =>

    navigator.splashscreen?.hide()
    setTimeout =>
      StatusBar?.show()
    , 500

    $(document).on 'resume', @resuming

  openView: (viewName, args...) ->
    @currentView?.unmount()

    @currentView = new Poems.Views[viewName](args...)
    @currentView.renderLayout()
    @currentView.mount()
    @currentView.render()

  router: ->
    @f7view.router

  render: (template, args...) ->
    Util.render(template, args...)

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

  resuming: ->
    @notifications?.clearAll()
