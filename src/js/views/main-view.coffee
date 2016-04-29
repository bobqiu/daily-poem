require "./main-animator"

class AP.MainView extends BaseView
  constructor: (@identifier) ->

  mount: ->
    @container = $(document)

    @container.on 'click', '.x-random', @openRandom
    @container.on 'click', '.x-share', @share
    @container.on 'click', '.x-like', @like

    @animator = new AP.MainAnimator(this)

  unmount: ->
    @animator.unmount()

    @container.off 'click', '.x-random', @openRandom
    @container.off 'click', '.x-share', @share
    @container.off 'click', '.x-like', @like

  renderLayout: ->
    @loadTemplateOnMainPage 'pages/main'

  render: (next) ->
    console.xdebug "rendering main view for #{@identifier}"

    if typeof @identifier is 'string' and @identifier.match(/^\d+$/)
      Model.get Number(@identifier), (poem) =>
        @identifier = poem.date()
        @renderDateWithSiblings poem.date(), next
    else
      @renderDateWithSiblings XDate.from(@identifier) ? Model.date, next

  renderDateWithSiblings: (date, next) ->
    Model.setDate date
    count = 0
    done = -> ++count == 3 and next?()
    @renderDate date,        (html) => $('.smm-swiper-slide.current').html html; done()
    @renderDate date.prev(), (html) => $('.smm-swiper-slide.prev').html html; done()
    @renderDate date.next(), (html) => $('.smm-swiper-slide.next').html html; done()

  renderDate: (date, next) ->
    console.xdebug "will render poem for #{date}"

    Model.getForDate date, (poem) =>
      console.xdebug "rendering poem for #{date}"

      if not poem
        return next null

      if date.eq Model.date.last().next()
        return next @renderTemplate 'tomorrow', appDate: date.formattedString()

      if date.gt Model.date.last().next()
        return next null

      context = Object.assign {}, poem, domId: "poem-#{poem.id}", appDate: date.formattedString(), liked: poem.isLiked()
      next @renderTemplate 'poem', context

  openRandom: (e) =>
    Router.go "poems", Model.randomPoemId()

  share: (e) =>
    Model.getCurrent (poem) =>
      App.deviceInfo.share text: poem.content, heading: poem.heading(), url: poem.getUrl()

  like: (e) =>
    target = $(e.target).closest(".x-like")
    icon = $(target).find('i')

    Util.toggleButton(target)
    action = if icon.hasClass('filled') then 'remove' else 'add'
    icon["#{action}Class"]("gray")

    Model.getCurrent (poem) =>
      poem.like()
