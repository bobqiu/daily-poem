millisecondsInDay = 86400 * 1000

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

