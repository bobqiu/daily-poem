class AP.CalendarView extends BaseView
  render: (next) ->
    @loadTemplateOnMainPage 'pages/calendar'

    calendar = @f7app().calendar
      container: '#calendar-inline-container',
      weekHeader: false,
      toolbarTemplate: @renderTemplate('shared/calendar-toolbar')
      value: [Model.date.getDate()]
      disabled: [ {from: Model.date.last().getDate()}, {to: Model.date.first().getDate()} ]
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
