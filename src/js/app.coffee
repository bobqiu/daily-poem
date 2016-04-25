class Poems.App
  constructor: ->
    @sidebar = new Poems.Views.Sidebar
    @sidebar.show()

    @f7app = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: true
    @f7view = @f7app.addView '.view-main', dynamicNavbar: true

    navigator.splashscreen?.hide()
    setTimeout =>
      StatusBar?.show()
    , 500

    Model.load =>
      Router.route()

      setTimeout =>
        @notifications = new Poems.Services.Notifications
        @notifications.setReminders()
      , 100

      @lifecycle = new Poems.Services.Lifecycle

      if @screenshotsMode
        @screenshots ?= Poems.Services.Screenshots
        @screenshots.enable()
        @screenshots.performNextTestAction()
