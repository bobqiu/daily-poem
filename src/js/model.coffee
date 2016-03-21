class Poems.Model
  constructor: ->
    @currentDate = new Date

  prevDate: -> new Date(@currentDate.getTime() - 86400 * 1000)
  nextDate: -> new Date(@currentDate.getTime() + 86400 * 1000)

  moveDateForward: -> @currentDate = @nextDate()
  moveDateBackward: -> @currentDate = @prevDate()

  canMoveForward: -> Util.dateString(@currentDate) isnt Util.dateString(@lastDate)
  canMoveBackward: -> Util.dateString(@currentDate) isnt Util.dateString(@firstDate)
  canMove: (direction) -> if direction is 1 then @canMoveForward() else @canMoveBackward()

  moveDate: (days) ->
    @currentDate = new Date(@currentDate.getTime() + days * 86400 * 1000)
    console.log "move current date to", @currentDate

  getPoemForDate: (date, next) ->
    dateKey = Util.dateString date
    id = @mapping[dateKey]

    console.log "loading data for", dateKey

    unless id
      console.warn "no data for", dateKey
      return next ''

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

  loadMapping: (next) ->
    $.get "poems/summary.json", (res) =>
      @mapping = res.mapping
      @descriptors = res.items

      allDates = Object.keys(@mapping)
      @firstDate = new Date allDates[0]
      @lastDate = new Date allDates[allDates.length - 1]

      next()
