class AP.SidebarView extends BaseView
  mount: ->
    $('.sidebar').on 'open', =>

  renderLayout: (next) ->
    $('#sidebar').html @renderTemplate('sidebar')
