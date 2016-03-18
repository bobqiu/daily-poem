module.exports =
  go: (path) ->
    console.log "opening #{path}"
    location.hash = path

  route: ->
    hash = decodeURIComponent location.hash.slice(1)
    switch
      when hash == '' then return
      when hash == 'favorites'
        App.mainView.router.loadContent App.render('favorites')

      when hash.match /poems\//
        [_, poemId] = hash.split('/')
        $.get "poems/#{poemId}.html", (res) ->
          html = App.render('poem', content: res, poemId: "poem-#{poemId}")
          App.mainView.router.loadContent(html)

    return false
    # when hash in page_names
    #   load_page "#{hash}.html", null, ->
    #     $("#sidebar").panel('close')
    #     $('#page_content').enhanceWithin()
    #     $('body').trigger("app:page_loaded:#{hash}_view")
    # when hash.match(/page:/)
    #   page = hash.replace('page:', '')
    #   load_page "pages/#{page}.html", null, -> $("#sidebar").panel('close')

$ ->
  $(window).on 'hashchange', Router.route
  $(document).on "click", 'a.action', (e) -> Router.go $(this).attr('href')
  $(document).on 'click', 'a.back.link', (e) -> Router.go ''

  Router.route()
