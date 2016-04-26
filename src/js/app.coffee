class AP.App
  constructor: ->
    @sidebar = new AP.SidebarView
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
        @notifications = new AP.Notifications
        @notifications.setReminders()
      , 100

      @lifecycle = new AP.Lifecycle

      if @screenshotsMode
        @screenshots ?= AP.Screenshots
        @screenshots.enable()
        @screenshots.performNextTestAction()
