class Poems.Router
  constructor: ->
    $(window).on 'hashchange', =>
      @route()

    $(document).on "click", 'a.action', (e) =>
      @go $(e.target).closest("a.action").attr('href')

    $(document).on 'click', 'a.back.link', (e) =>
      @go ''

  go: (path) ->
    console.log "going to #{path}"
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

  main:          -> @openView 'Main', Model.currentDate
  favorites:     -> @openView 'Favorites'
  about:         -> @openView 'About'
  developer:     -> @openView 'DeveloperMenu'
  tomorrow:      -> @openView 'Main', Util.nextDate Model.lastAllowedDate()
  poems: (id)    -> @openView 'Main', id
  calendar: (id) -> @openView 'Calendar'

  openView: (args...) ->
    App.openView args...
