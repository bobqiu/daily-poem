class Poems.App
  constructor: ->
    @sidebar = new Poems.Views.Sidebar
    @sidebar.show()

    @f7app = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
    @f7view = @f7app.addView '.view-main', dynamicNavbar: true

    if @screenshotsMode
      @screenshots ?= Poems.Services.Screenshots
      @screenshots.enable()
      @screenshots.performNextTestAction()

    Model.loadMapping =>
      Router.route()
      setTimeout =>
        @notifications = new Poems.Services.Notifications
        @notifications.setReminders()
      , 100

    navigator.splashscreen?.hide()
    setTimeout =>
      StatusBar?.show()
    , 500

    @lifecycle = new Poems.Services.Lifecycle

  openView: (viewName, args...) ->
    @currentView?.unmount()
    @currentView = new Poems.Views[viewName](args...)
    @currentView.show()
