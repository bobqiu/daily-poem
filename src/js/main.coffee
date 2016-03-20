require "framework7"
window.$$ = Dom7
window.$ = require "jquery"
window.Handlebars = require "handlebars/runtime"

require "../css/main.scss"
require "../about.html"
require "../demo.html"

window.Model = require "./model"
window.App = require "./app"
Handlebars.registerHelper require "./helpers"

$ ->
  window.App7 = new Framework7 dynamicPageUrl: 'page-{{name}}', pjax: yes # ajaxLinks: 'ajax'
  App.mainView = App7.addView '.view-main', dynamicNavbar: true

window.Router = require "./router"

$ ->
  Model.init()
  App.init()

  # App.poems = []
  # requests = []
  # currentPoemIndex = 2
  # for i in [1..6]
  #   requests.push $.get("poems/#{i}.html").then (res) ->
  #     App.poems.push res
  #
  # Promise.all(requests).then ->
  #   $('.swiper-slide-prev .poem-box').html App.render 'poem', content: App.poems[1], id: 1
  #   $('.swiper-slide-active .poem-box').html App.render 'poem', content: App.poems[2], id: 2
  #   $('.swiper-slide-next .poem-box').html App.render 'poem', content: App.poems[3], id: 3

  # App.swiper = App7.swiper '.swiper-container',
  #   loop: true,
  #   # initialSlide: 1,
  #   onSlideNextEnd: (s) ->
  #     # s.removeSlide(0) if s.slides.length is 2
  #     # s.removeSlide(s.activeIndex - 4) if s.slides.length > 5
  #     # currentPoemIndex++
  #     # html = App.render 'poem', content: App.poems[currentPoemIndex], id: currentPoemIndex
  #     # console.log $('.swiper-slide-prev').get(0)
  #     # console.log $('.swiper-slide-active').get(0)
  #     # console.log $('.swiper-slide-next').get(0)
  #     # s.appendSlide "<div class='swiper-slide'>#{html}</div>"
  #   onSlidePrevEnd: (s) ->
  #     # s.removeSlide(2) if s.activeIndex is 0
  #     # s.removeSlide(s.activeIndex + 4) if s.slides.length > 5
  #     # currentPoemIndex--
  #     # html = App.render 'poem', content: App.poems[currentPoemIndex], id: currentPoemIndex
  #     # s.prependSlide "<div class='swiper-slide'>#{html}</div>"

  # App.swiper.removeSlide(3)

  width = 100
  unit = '%'

  day = 20
  done = yes

  adjust = (forward) ->
    return unless done
    done = no

    shift = Number $('.smm-swiper-viewport').attr('data-shift')
    shift = shift + (if forward then -1 else 1)  * width

    $('.smm-swiper-viewport').attr('data-shift', shift)
    $('.smm-swiper-viewport').css transform: "translate3d(#{shift}#{unit}, 0px, 0px)"

    prev = $('.smm-swiper-slide.prev')
    current = $('.smm-swiper-slide.current')
    next = $('.smm-swiper-slide.next')

    if forward then Model.moveDateForward() else Model.moveDateBackward()

    setTimeout( ->
      if forward
        current.toggleClass('current prev')
        next.toggleClass('next current')
        prev.toggleClass('prev next').css transform: "translate3d(#{-shift + width}#{unit}, 0%, 0px)"
        prev.html(App.renderPoemForDate Model.nextDate() )
      else
        prev.removeClass('prev').addClass('current')
        current.removeClass('current').addClass('next')
        next.removeClass('next').addClass('prev').css transform: "translate3d(#{-shift - width}#{unit}, 0%, 0px)"
        next.html(App.renderPoemForDate Model.prevDate() )
      done = yes
    , 500)

    true

  $(document).on 'click', '.smm-swiper-controls .prev', (e) -> adjust false
  $(document).on 'click', '.smm-swiper-controls .next', (e) -> adjust true
