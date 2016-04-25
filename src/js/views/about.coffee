class Poems.Views.About extends BaseView
  render: (next) ->
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
