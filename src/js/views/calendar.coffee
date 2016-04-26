class Poems.Views.Calendar extends BaseView
  render: (next) ->
    @loadTemplateOnMainPage 'pages/calendar'

    console.log [ {from: Model.currentDate.last().getDate()}, {to: Model.currentDate.first().getDate()} ]

    calendar = @f7app().calendar
      container: '#calendar-inline-container',
      weekHeader: false,
      toolbarTemplate: @renderTemplate('shared/calendar-toolbar')
      value: [Model.currentDate.getDate()]
      disabled: [ {from: Model.currentDate.last().getDate()}, {to: Model.currentDate.first().getDate()} ]
      onOpen: (p) =>
        $('.calendar-custom-toolbar .center').text Util.t('months')[p.currentMonth] + ', ' + p.currentYear
        $('.calendar-custom-toolbar .left .link').click => calendar.prevMonth()
        $('.calendar-custom-toolbar .right .link').click => calendar.nextMonth()
      onMonthYearChangeStart: (p) =>
        $('.calendar-custom-toolbar .center').text(Util.t('months')[p.currentMonth] + ', ' + p.currentYear)
        $('.calendar-custom-toolbar .center').text(Util.t('months')[p.currentMonth] + ', ' + p.currentYear)
      onDayClick: (p, dayContainer, year, month, day) =>
        date = new Date(year, month, day)
        Router.go("poems/#{Util.dateString date}")
        @f7app().closePanel()

    next?()
