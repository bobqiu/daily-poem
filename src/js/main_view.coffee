class Poems.MainView
  width = 100
  animationDuration = 250
  defaultUnit = '%'
  screenWidth = $(window).width()

  translate3d = (value, unit = defaultUnit) -> "translate3d(#{value}#{unit}, 0px, 0px)"

  constructor: ->
    @done = yes
    @shift = 0

    $(document).on 'click', '.smm-swiper-controls .prev', (e) => @adjust +1
    $(document).on 'click', '.smm-swiper-controls .next', (e) => @adjust -1
    $(document).on 'click', '.x-share', (e) => App.sharePoem()
    $(document).on 'click', '.x-like', (e) -> Util.toggleButton(e.currentTarget); App.likePoem()

    @viewport = $('.smm-swiper-viewport')

    @initSwiping()

  adjust: (direction) ->
    return unless Model.canMove(direction)
    return unless @done
    @done = no

    @shift = @shift - direction * width

    Model.moveDate(direction)

    @viewport.addClass "animating"
    @viewport.css transform: translate3d(@shift)

    prev = $('.smm-swiper-slide.prev')
    curr = $('.smm-swiper-slide.current')
    next = $('.smm-swiper-slide.next')

    setTimeout =>
      if direction is +1
        curr.toggleClass('current prev')
        next.toggleClass('next current')
        prev.toggleClass('prev next').css transform: translate3d(-@shift + width)
        App.renderPoemForDate Model.nextDate(), (html) =>
          prev.html html
          @done = yes
      else
        prev.toggleClass('prev current')
        curr.toggleClass('current next')
        next.toggleClass('next prev').css transform: translate3d(-@shift - width)
        App.renderPoemForDate Model.prevDate(), (html) =>
          next.html html
          @done = yes

      @viewport.removeClass "animating"
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
