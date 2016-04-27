class AP.Router
  constructor: ->
    if @constructor.disabled
      console.warn "router disabled"
      return

    $(window).on 'hashchange', =>
      @route()

    $(document).on "click", 'a.action', (e) =>
      @go $(e.target).closest("a.action").attr('href')

    $(document).on 'click', 'a.back.link', (e) =>
      @go ''

  go: (path) ->
    console.xlog "going to #{path}"
    location.hash = path

  route: =>
    return if @constructor.disabled

    hash = decodeURIComponent location.hash.slice(1)
    [controller, id, other...] = hash.split('/')

    controller = 'main' unless controller
    routes = this

    if routes[controller]
      console.log "Router.#{controller}(#{id ? ''})"
      routes[controller](id)
    else
      console.warn "no route for Router.#{controller}(#{id ? ''})"

    return false

  main:          -> @openView 'Main', Model.date
  favorites:     -> @openView 'Favorites'
  about:         -> @openView 'About'
  developer:     -> @openView 'DeveloperMenu'
  tomorrow:      -> @openView 'Main', Model.date.last().next()
  poems: (id)    -> @openView 'Main', id
  calendar: (id) -> @openView 'Calendar'

  openView: (viewName, args...) ->
    @currentView?.unmount()
    @currentView = new AP["#{viewName}View"](args...)
    @currentView.show()
