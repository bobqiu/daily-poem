{floor, abs} = Math

class AP.MainView extends BaseView
  width = 100
  defaultUnit = '%'
  screenWidth = $(window).width()
  translate3d = (value, unit = defaultUnit) -> "translate3d(#{value}#{unit}, 0px, 0px)"
  transitionDuration = '400ms'

  constructor: (@identifier) ->

  renderLayout: ->
    @loadTemplateOnMainPage 'pages/main'

  render: (next) ->
    identifier = @identifier
    renderDate = (date) => @renderPoemsForDate date, next

    console.xdebug "rendering main view for #{@identifier}"
    switch
      when typeof identifier is 'string' and identifier.match(/\d{4}-\d{2}-\d{2}/)
        date = new XDate(identifier)
        renderDate date
      when typeof identifier is 'string' and identifier.match(/^\d+$/)
        id = Number(identifier)
        Model.get id, (poem) =>
          @identifier = poem.date()
          @render(next)
      when identifier instanceof XDate
        renderDate identifier
      else
        renderDate Model.date

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

  onShare: (e) =>
    @sharePoem()

  onLike: (e) =>
    target = $(e.target).closest(".x-like")
    icon = $(target).find('i')

    Util.toggleButton(target)
    action = if icon.hasClass('filled') then 'remove' else 'add'
    icon["#{action}Class"]("gray")
    @likePoem()

  adjust: (direction) ->
    log 'adjusting if needed'

    return unless Model.date.canMove(direction)
    return unless @done
    @done = no

    log 'adjusting'

    @container = $('.smm-swiper')
    @viewport = $('.smm-swiper-viewport')

    @shift = @shift - direction * width

    Model.date.move(direction)

    # @container.addClass "panning"
    @viewport.addClass "animating"
    @viewport.css transform: translate3d(@shift), "transition-duration": transitionDuration

    curr = @viewport.find('.smm-swiper-slide.current').show()
    prev = @viewport.find('.smm-swiper-slide.prev').show()
    next = @viewport.find('.smm-swiper-slide.next').show()

    finishAnimation = =>
      @done = yes
      @viewport.removeClass "animating"
      @container.removeClass "panning"
      # $('.smm-swiper-slide.prev', @viewport).hide()
      # $('.smm-swiper-slide.next', @viewport).hide()
      @viewport.find('.smm-swiper-slide:not(.current) .content-block').scrollTop(0)


    @viewport.one "transitionend", =>
      if direction is +1
        curr.toggleClass('current prev')
        next.toggleClass('next current')
        prev.toggleClass('prev next').css transform: translate3d(-@shift + width)
        @renderPoemForDate Model.date.next(), (html) =>
          prev.html html
          finishAnimation()

      else
        prev.toggleClass('prev current')
        curr.toggleClass('current next')
        next.toggleClass('next prev').css transform: translate3d(-@shift - width)
        @renderPoemForDate Model.date.prev(), (html) =>
          next.html html
          finishAnimation()

    true

  initSwiping: ->
    @viewport = $('.smm-swiper-viewport')
    @hammer = new Hammer $('#poem-swiper')[0], {}
    @hammer.get('pan').set direction: Hammer.DIRECTION_ALL

    animateFullSlideOnly = no

    @hammer.on 'tap', (e) =>
      unless $(e.target).closest(".poem-controls").length
        e.preventDefault()
        direction = if e.center.x > screenWidth / 2 then 1 else -1
        @adjust direction

    @hammer.on 'pan', (e) =>
      if !@panningStep? and !@scrollingStarted?
        clear()

      dx = e.deltaX
      dy = e.deltaY
      dxPc = dx / screenWidth * 100
      vxo = e.overallVelocityX

      log "pan dx=#{dx} / #{dxPc.toFixed(2)}% dy=#{dy} vx=#{vxo.toFixed(2)}
          #{Util.dumpBools first: e.isFirst, cont: @panningStep, final: e.isFinal, vertical: tooVerticalToStart}"

      if @scrollingStarted
        log "  scrolling"
        log "  scrolling ended"  if e.isFinal
        delete @scrollingStarted if e.isFinal
        return

      tooVerticalToStart = !@panningStep? and (abs(dy) > 20 or abs(dx) < 10)

      if tooVerticalToStart
        log "  scrolling started"
        @scrollingStarted = true
        return

      e.preventDefault()
      @panningStep ?= 0
      @panningStep += 1

      if animateFullSlideOnly

        if e.isFinal and abs(dxPc) >= 15
          delete @panningStep
          direction = if dx > 0 then -1 else +1
          @viewport.removeClass("swiping")
          @adjust direction

      else

        @dxStep ?= 0
        @dxStep = dx - @dxStep

        @viewport.addClass("swiping")

        unless e.isFinal
          dxPc = @panningStep * 1.0 * (if dx < 0 then -1 else 1)
          log "  moving step=#{@panningStep} #{dxPc}% / #{@dxStep}px"
          @viewport.css transform: translate3d(@shift + dxPc, '%'), 'transition-duration': '0ms'

        else
          delete @panningStep
          delete @dxStep

          direction = if e.deltaX > 0 then -1 else +1
          log "  final #{dx}px #{dxPc}% dir=#{direction} vel=#{vxo.toFixed(2)}"
          log ""

          if (abs(dxPc) >= 50 or abs(vxo) > 0.5) and Model.date.canMove(direction)
            @viewport.css "transition-duration": transitionDuration
            @adjust direction
          else
            @viewport.css "transition-duration": transitionDuration
            @viewport.css transform: translate3d(@shift, '%')

          @viewport.removeClass("swiping")

  renderPoemForDate: (date, next) ->
    console.xdebug "will render poem for #{date}"

    Model.getForDate date, (poem) =>
      console.debug "rendering poem for #{date}"

      if not poem
        return next ""

      if date.eq Model.date.last().next()
        return next @renderTemplate 'tomorrow', appDate: date.formattedString()

      if date.gt Model.date.last().next()
        return next ""

      context = Object.assign {}, poem, domId: "poem-#{poem.id}", appDate: date.formattedString(), liked: poem.isLiked()
      html = @renderTemplate 'poem', context
      next html

  renderPoemsForDate: (date, next) ->
    Model.setDate date
    count = 0
    done = -> ++count == 3 && next && next()
    @renderPoemForDate date, (html) => $('.smm-swiper-slide.current').html html; done()
    @renderPoemForDate date.prev(), (html) => $('.smm-swiper-slide.prev').html html; done()
    @renderPoemForDate date.next(), (html) => $('.smm-swiper-slide.next').html html; done()

  openRandomPoem: ->
    Router.go "poems/#{Model.randomPoemId()}"

  sharePoem: ->
    Model.getCurrent (poem) =>
      console.log "opening the sharing dialog..."
      if window.plugins?.socialsharing?
        window.plugins.socialsharing.share poem.content, poem.heading(), null, poem.getUrl()

  likePoem: ->
    Model.currentPoem().like()

logging = no
log = (args...) -> console.log(args...) if logging
clear = -> console.clear() if logging
