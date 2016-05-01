class AP.Application
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

      @notifications = new AP.Notifications
      @clickManager = new AP.ClickManager
      @deviceInfo = new AP.DeviceInfo
      @lifecycle = new AP.Lifecycle
      @sharingManager = new AP.SharingManager

      if @screenshotsMode
        @screenshots ?= AP.Screenshots
        @screenshots.enable()
        @screenshots.performNextTestAction()
