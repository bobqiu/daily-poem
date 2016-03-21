module.exports =
  dateString: (date) ->
    date.toJSON().substring(0, 10)
