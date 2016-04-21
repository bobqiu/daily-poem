class Poems.Router
  constructor: ->
    $(window).on 'hashchange', @route
    $(document).on "click", 'a.action', (e) => @go $(e.currentTarget).attr('href')
    $(document).on 'click', 'a.back.link', (e) => @go ''

  go: (path) ->
    location.hash = path

  route: =>
    hash = decodeURIComponent location.hash.slice(1)
    [controller, id, other...] = hash.split('/')

    controller = 'main' unless controller
    routes = this
    if routes[controller]
      console.log "routing to Router.#{controller}(#{id ? ''})"
      routes[controller](id)
    else
      console.warn "no route for Router.#{controller}(#{id ? ''})"

    return false

  main: -> App.openView('Main', Model.currentDate)
  favorites: -> App.openView('Favorites')
  about: ->App.openView('About')
  developer: ->App.openView('Developer')
  tomorrow: -> App.openView('Main', Util.nextDate Model.lastAllowedDate())
  poems: (id) -> App.openView('Main', id)
  calendar: (id) -> App.openView('Calendar')
