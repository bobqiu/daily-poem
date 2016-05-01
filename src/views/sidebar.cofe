class AP.SidebarView extends BaseView
  mount: ->
    overlay = $('.panel-overlay')
    sidebar = $('.sidebar')
    opened = false

    overlay.on 'transitionend', (e) =>
      if opened isnt true
        overlay.hide()

    sidebar.on 'open', =>
      opened = true
      overlay.show()
      setTimeoutTo 10, ->
        overlay.addClass('active')

    sidebar.on 'opened', =>

    sidebar.on 'close', =>
      overlay.show()
      setTimeoutTo 10, ->
        overlay.removeClass('active')

    sidebar.on 'closed', =>
      opened = false

  renderLayout: (next) ->
    $('#sidebar').html @renderTemplate('sidebar')
