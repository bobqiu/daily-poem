class window.BaseView
  router: ->
    App.f7view.router

  renderLayout: ->
  render: ->
  mount: ->
  unmount: ->

  show: ->
    @renderLayout()
    @render()
    @mount()

  renderTemplate: (template, args...) ->
    Util.render(template, args...)

  load: (content) ->
    @router().loadContent content

  loadTemplate: (template, args...) ->
    @load @renderTemplate template, args...

  loadTemplateOnMainPage: (template, args...) ->
    $('#pages').html @renderTemplate template, args...

  f7app: ->
    App.f7app
