class Poems.Model
  constructor: ->
    @poemsCache = new Poems.Cache

  prevDate: -> Util.prevDate @currentDate
  nextDate: -> Util.nextDate @currentDate

  moveDateForward: -> @currentDate = @nextDate()
  moveDateBackward: -> @currentDate = @prevDate()

  canMoveForward: -> Util.dateString(@currentDate) <= Util.dateString(@lastDate)
  canMoveBackward: -> Util.dateString(@currentDate) > Util.dateString(@firstDate)
  canMove: (direction) -> if direction is 1 then @canMoveForward() else @canMoveBackward()

  hasDataFor: (date) ->
    Util.dateString(@firstDate) <= Util.dateString(date) <= Util.dateString(@lastDate)

  moveDate: (days) ->
    @setDate new Date(@currentDate.getTime() + days * 86400 * 1000)

  setDate: (date) ->
    @currentDate = date
    console.log "move current date to", Util.dateString @currentDate

  getPoemForDate: (date, next) ->
    dateKey = Util.dateString date
    id = @mapping[dateKey]

    if not id
      return next last: yes
    if @poemsCache.has dateKey
      return next @poemsCache.get dateKey

    console.log "loading data for", dateKey
    $.getJSON "poems/#{id}.json", (res) =>
      @poemsCache.set dateKey, res
      next res

  loadMapping: (next) ->
    $.getJSON "poems/summary.json", (res) =>
      @mapping = res.mapping
      @descriptors = res.items

      allDates = Object.keys(@mapping)
      @firstDate = new Date allDates[0]
      @lastDate = new Date allDates[allDates.length - 1]

      next()

class Poems.Cache
  constructor: ->
    @data = new Map

  set: (key, item) ->
    @data.set key, item
    @cleanup key if @data.size > 20

  get: (key) ->
    @data.get key

  has: (key) ->
    @data.has key

  cleanup: (key) ->
    keysToLeave = [ key, Util.dateString(Util.nextDate(new Date(key))), Util.dateString(Util.prevDate(new Date(key))) ]
    @data.forEach (object, key, map) =>
      if key not in keysToLeave
        @data.delete(key)
