class Poems.MainView
  width = 100
  animationDuration = 250
  defaultUnit = '%'
  screenWidth = $(window).width()
  translate3d = (value, unit = defaultUnit) -> "translate3d(#{value}#{unit}, 0px, 0px)"

  constructor: ->
    @done = yes
    @shift = 0

    $(document).on 'click', '.x-random', (e) => App.openRandomPoem()
    $(document).on 'click', '.x-share', (e) => App.sharePoem()
    $(document).on 'click', '.x-like', (e) =>
      e.stopPropagation()
      Util.toggleButton(e.currentTarget)
      icon = $(e.currentTarget).find('i')
      action = if icon.hasClass('filled') then 'remove' else 'add'
      icon["#{action}Class"]("gray")
      App.likePoem()

    @initSwiping()

  unmount: ->
    @hammer.off 'swipe'
    $(document).off 'click', '.x-random'
    $(document).off 'click', '.x-share'
    $(document).off 'click', '.x-like'

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

    curr = $('.smm-swiper-slide.current', @viewport).show()
    prev = $('.smm-swiper-slide.prev', @viewport).show()
    next = $('.smm-swiper-slide.next', @viewport).show()

    animationEnd = =>
      @done = yes
      @viewport.removeClass "animating"
      @container.removeClass "panning"
      # $('.smm-swiper-slide.prev', @viewport).hide()
      # $('.smm-swiper-slide.next', @viewport).hide()
      $('.smm-swiper-slide:not(.current) .content-block', @viewport).scrollTop(0)


    setTimeout =>
      if direction is +1
        curr.toggleClass('current prev')
        next.toggleClass('next current')
        prev.toggleClass('prev next').css transform: translate3d(-@shift + width)
        App.renderPoemForDate Model.nextDate(), (html) =>
          prev.html html
          animationEnd()

      else
        prev.toggleClass('prev current')
        curr.toggleClass('current next')
        next.toggleClass('next prev').css transform: translate3d(-@shift - width)
        App.renderPoemForDate Model.prevDate(), (html) =>
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
