class AP.Router
  constructor: ->
    if @constructor.disabled
      console.warn "router disabled"
      return

    $(window).on 'hashchange', =>
      if @skipNext
        @skipNext = false
        return

      @route()

    $(document).on "click", 'a.action', (e) =>
      link = $(e.target).closest("a.action")
      return if $(link).hasClass("external")
      return if link.attr('href')[0] isnt '#'
      @go link.attr('href')

    $(document).on 'click', 'a.back.link', (e) =>
      @go ''

  go: (path...) ->
    path = path.join("/")
    console.xlog "going to #{path}"

    @skipNext = true
    location.hash = path
    @route()

  replace: (path...) ->
    path = path.join("/")
    @skipNext = true
    location.hash = path

  route: =>
    return if @constructor.disabled or @disabled

    hash = decodeURIComponent location.hash.slice(1)
    [controller, id, other...] = hash.split('/')

    controller = 'main' unless controller
    routes = this

    if routes[controller]
      console.log "Router.#{controller}(#{id ? ''})"
      routes[controller](id)
    else
      console.warn "no route for Router.#{controller}(#{id ? ''})"
      @go ''

  main:          -> @openView 'Main', Model.date
  favorites:     -> @openView 'Favorites'
  about:         -> @openView 'About'
  developer:     -> @openView 'DeveloperMenu'
  today:         -> @openView 'Main', Model.date
  tomorrow:      -> @openView 'Main', Model.date.last().next()
  poems: (id)    -> @openView 'Main', id
  calendar: (id) -> @openView 'Calendar'

  openView: (viewName, args...) ->
    @currentView?.unmount()
    @currentView = new AP["#{viewName}View"](args...)
    @currentView.show()
    null
