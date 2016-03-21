class Poems.MainView
  width = 100
  animationDuration = 250
  unit = '%'

  translate3d = (value) -> "translate3d(#{value}#{unit}, 0px, 0px)"

  constructor: ->
    @done = yes
    @shift = 0
    $(document).on 'click', '.smm-swiper-controls .prev', (e) => @adjust +1
    $(document).on 'click', '.smm-swiper-controls .next', (e) => @adjust -1

  adjust: (direction) ->
    return unless @done
    @done = no

    @shift = @shift - direction * width

    Model.moveDate(direction)

    $('.smm-swiper-viewport').css transform: translate3d(@shift)

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
    , animationDuration

    true
