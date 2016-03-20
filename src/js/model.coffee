module.exports =
  init: ->
    @currentDate = new Date

  prevDate: -> new Date(@currentDate.getTime() - 86400 * 1000)
  nextDate: -> new Date(@currentDate.getTime() + 86400 * 1000)
  moveDateForward: -> @currentDate = @nextDate()
  moveDateBackward: -> @currentDate = @prevDate()

  getPoemForDate: (date) ->
    console.assert "@poems are not loaded yet" unless @poems
    id = Math.floor( Math.random() * @poems.length )
    [@poems[id], id]

  loadPoemsIntoMemory: (callback) ->
    @poems = []
    requests = []
    for i in [1..6]
      requests.push $.get("poems/#{i}.html").then (res) => @poems.push res
    Promise.all(requests).then =>
      @poemsLoaded = true
      callback()
