module.exports =
  init: ->
    @currentDate = new Date

  prevDate: -> new Date(@currentDate.getTime() - 86400 * 1000)
  nextDate: -> new Date(@currentDate.getTime() + 86400 * 1000)
  moveDateForward: -> @currentDate = @nextDate()
  moveDateBackward: -> @currentDate = @prevDate()
  moveDate: (days) -> new Date(@currentDate.getTime() + days * 86400 * 1000)

  getPoemForDate: (date, next) ->
    id = Math.floor( Math.random() * 10 + 1 )
    $.get "poems/#{id}.json", (res) ->
      next res

  # loadPoemsIntoMemory: (callback) ->
  #   @poems = []
  #   requests = []
  #   for i in [1..11]
  #     requests.push $.get("poems/#{i}.json").then (res) => @poems.push res
  #   Promise.all(requests).then =>
  #     @poemsLoaded = true
  #     callback()
