class AP.DeveloperMenuView extends BaseView
  render: (next) ->
    data = firstDate: Util.dateString(Model.firstDate), lastDate: Util.dateString(Model.lastDate)
    @loadTemplateOnMainPage 'pages/developer', data
    next?()
