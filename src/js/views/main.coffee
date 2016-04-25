class Poems.Views.Main extends BaseView
  width = 100
  animationDuration = 250
  defaultUnit = '%'
  screenWidth = $(window).width()
  translate3d = (value, unit = defaultUnit) -> "translate3d(#{value}#{unit}, 0px, 0px)"

  constructor: (@identifier) ->

  renderLayout: ->
    @loadTemplateOnMainPage 'pages/main'

  render: (next) ->
    identifier = @identifier
    renderDate = (date) => @renderPoemsForDate date, next

    switch
      when typeof identifier is 'string' and identifier.match(/\d{4}-\d{2}-\d{2}/)
        date = new Date(identifier)
        renderDate date
      when typeof identifier is 'string' and identifier.match(/^\d+$/)
        id = Number(identifier)
        Model.getPoem id, (poem) =>
          @identifier = poem.date()
          @show(next)
      when identifier instanceof Date
        renderDate identifier
      else
        renderDate Model.currentDate

  mount: ->
    @done = yes
    @shift = 0

    $(document).on 'click', '.x-random', @onOpenRandom
    $(document).on 'click', '.x-share', @onShare
    $(document).on 'click', '.x-like', @onLike

    @initSwiping()

  unmount: ->
    @hammer.off 'swipe'
    $(document).off 'click', '.x-random', @onOpenRandom
    $(document).off 'click', '.x-share', @onShare
    $(document).off 'click', '.x-like', @onLike

  onOpenRandom: (e) => @openRandomPoem()

  onShare: (e) => @sharePoem()

  onLike: (e) =>
    e.stopPropagation()
    Util.toggleButton(e.currentTarget)
    icon = $(e.currentTarget).find('i')
    action = if icon.hasClass('filled') then 'remove' else 'add'
    icon["#{action}Class"]("gray")
    @likePoem()

  adjust: (direction) ->
    return unless Model.canMove(direction)
    return unless @done
    @done = no

    @container = $('.smm-swiper')
    @viewport = $('.smm-swiper-viewport')

    @shift = @shift - direction * width

    Model.moveDate(direction)

    @container.addClass "panning"
    @viewport.addClass "animating"
    @viewport.css transform: translate3d(@shift)

    curr = @viewport.find('.smm-swiper-slide.current').show()
    prev = @viewport.find('.smm-swiper-slide.prev').show()
    next = @viewport.find('.smm-swiper-slide.next').show()

    animationEnd = =>
      @done = yes
      @viewport.removeClass "animating"
      @container.removeClass "panning"
      # $('.smm-swiper-slide.prev', @viewport).hide()
      # $('.smm-swiper-slide.next', @viewport).hide()
      @viewport.find('.smm-swiper-slide:not(.current) .content-block').scrollTop(0)


    setTimeout =>
      if direction is +1
        curr.toggleClass('current prev')
        next.toggleClass('next current')
        prev.toggleClass('prev next').css transform: translate3d(-@shift + width)
        @renderPoemForDate Model.nextDate(), (html) =>
          prev.html html
          animationEnd()

      else
        prev.toggleClass('prev current')
        curr.toggleClass('current next')
        next.toggleClass('next prev').css transform: translate3d(-@shift - width)
        @renderPoemForDate Model.prevDate(), (html) =>
          next.html html
          animationEnd()
    , animationDuration

    true

  initSwiping: ->
    @hammer = new Hammer $('#poem-swiper')[0], {}
    @hammer.get('pan').set direction: Hammer.DIRECTION_HORIZONTAL
    @hammer.get('swipe').set direction: Hammer.DIRECTION_HORIZONTAL

    # @hammer.on 'pan', (e) =>
    #   direction = if e.deltaX > 0 then -1 else +1
    #   delta = Math.floor(e.deltaX / screenWidth * 100)
    #   if e.isFinal
    #     console.log  e.isFinal, e.deltaX, delta, direction
    #     if Math.abs(delta) >= 50
    #       @adjust direction
    #     else
    #       @viewport.css transform: translate3d(@shift, '%')
    #   else
    #     @viewport.css transform: translate3d(@shift + delta, '%')

    @hammer.on 'swipe', (e) =>
      direction = if e.deltaX > 0 then -1 else +1
      delta = Math.floor(e.deltaX / screenWidth * 100)
      if Math.abs(delta) >= 20
        @adjust direction

  renderPoemForDate: (date, next) ->
    Model.getPoemForDate date, (poem) =>
      appDate = Util.formatMonthAndDay(date)
      if Util.dateString(date) > Util.dateString(Model.lastAllowedDate())
        next @renderTemplate 'tomorrow', appDate: appDate
      else if poem.last
        next ""
      else
        context = Object.assign {}, poem, domId: "poem-#{poem.id}", appDate: appDate, liked: poem.isLiked()
        html = @renderTemplate 'poem', context
        next html

  renderPoemsForDate: (date, next) ->
    Model.setDate date
    count = 0
    done = -> ++count == 3 && next && next()
    @renderPoemForDate date, (html) => $('.smm-swiper-slide.current').html html; done()
    @renderPoemForDate Util.prevDate(date), (html) => $('.smm-swiper-slide.prev').html html; done()
    @renderPoemForDate Util.nextDate(date), (html) => $('.smm-swiper-slide.next').html html; done()

  openRandomPoem: ->
    Router.go "poems/#{Model.randomPoemId()}"

  sharePoem: ->
    Model.getCurrentPoem (poem) =>
      if window.plugins?.socialsharing?
        window.plugins.socialsharing.share poem.content, poem.heading(), null, poem.getUrl()

  likePoem: ->
    Model.currentPoem().like()
