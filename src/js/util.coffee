moment = require('moment')
moment.locale 'ru'

millisecondsInDay = 86400 * 1000
strings =
  en:
    months: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
  ru:
    months: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август' , 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь']

module.exports =
  today: ->
    new Date

  dateString: (date) ->
    year = date.getFullYear()
    month = date.getMonth() + 1
    day = date.getDate()
    month = '0' + month if month < 10
    day = '0' + day if day < 10
    "#{year}-#{month}-#{day}"

  prevDate: (date) ->
    new Date date.getTime() - millisecondsInDay

  nextDate: (date) ->
    new Date date.getTime() + millisecondsInDay

  formatMonthAndDay: (date) ->
    format = if @lang is 'ru' then "D MMMM" else "MMMM D"
    moment(date).format(format)

  lang: 'ru'

  t: (key) ->
    strings[@lang][key]
