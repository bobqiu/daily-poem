class Poems.Router
  constructor: ->
    $(window).on 'hashchange', @route
    $(document).on "click", 'a.action', (e) => @go $(e.currentTarget).attr('href')
    $(document).on 'click', 'a.back.link', (e) => @go ''

  go: (path) ->
    console.log "opening #{path}"
    location.hash = path

  route: ->
    hash = decodeURIComponent location.hash.slice(1)
    switch
      when hash == '' then return

      when hash == 'favorites'
        App.loadTemplate 'favorites'

      when hash.match /poems\//
        [_, poemId] = hash.split('/')
        $.get "poems/#{poemId}.html", (res) ->
          App.loadTemplate 'poem', content: res, poemId: "poem-#{poemId}"

      when hash.match /tomorrow/
        App.renderPoemsForDate Util.nextDate(Model.lastDate)

      when hash.match /about/
        App.renderAbout()

    return false

    # when hash in page_names
    #   load_page "#{hash}.html", null, ->
    #     $("#sidebar").panel('close')
    #     $('#page_content').enhanceWithin()
    #     $('body').trigger("app:page_loaded:#{hash}_view")
    # when hash.match(/page:/)
    #   page = hash.replace('page:', '')
    #   load_page "pages/#{page}.html", null, -> $("#sidebar").panel('close')

