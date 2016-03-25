class Poems.Router
  constructor: ->
    $(window).on 'hashchange', @route
    $(document).on "click", 'a.action', (e) => @go $(e.currentTarget).attr('href')
    $(document).on 'click', 'a.back.link', (e) => @go ''

  go: (path) ->
    console.log "opening #{path}"
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
      console.log routes[controller]
      console.log routes

    # switch
    #   when hash == '' then return
    #
    #   when hash == 'favorites'
    #     App.renderFavorites()
    #
    #   when hash.match /poems\//
    #     [_, poemId] = hash.split('/')
    #     Model.getPoem poemId, (poem) ->
    #       console.log poem, poem.date()
    #       App.renderPoemsForDate poem.date(), ->
    #
    #       # $.get "poems/#{poemId}.html", (res) ->
    #       #   App.loadTemplate 'poem', content: res, poemId: "poem-#{poemId}"
    #
    #   when hash.match /tomorrow/
    #     App.renderPoemsForDate Util.nextDate(Model.lastDate)
    #
    #   when hash.match /about/
    #     App.renderAbout()

    return false

  main: -> App.renderMain()
  favorites: -> App.renderFavorites()
  about: ->App.renderAbout()
  tomorrow: -> App.renderPoemsForDate Util.nextDate(Model.lastDate)
  poems: (id) ->
    Model.getPoem id, (poem) ->
      App.renderMain poem.date()
