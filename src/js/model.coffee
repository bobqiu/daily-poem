class Poems.Model
  constructor: ->
    @poemsCache = new Poems.Cache
    @likes = new Set JSON.parse(localStorage.likes ? '[]')
    @currentDate = new Date

  prevDate: -> Util.prevDate @currentDate
  nextDate: -> Util.nextDate @currentDate

  moveDateForward: -> @currentDate = @nextDate()
  moveDateBackward: -> @currentDate = @prevDate()

  canMoveForward: -> Util.dateString(@currentDate) <= Util.dateString(@lastDate)
  canMoveBackward: -> Util.dateString(@currentDate) > Util.dateString(@firstDate)
  canMove: (direction) -> if direction is 1 then @canMoveForward() else @canMoveBackward()

  currentPoem: ->
    @poemsCache.get Util.dateString @currentDate

  getCurrentPoem: (next) ->
    @getPoemForDate @currentDate, next

  hasDataFor: (date) ->
    Util.dateString(@firstDate) <= Util.dateString(date) <= Util.dateString(@lastDate)

  moveDate: (days) ->
    @setDate new Date(@currentDate.getTime() + days * 86400 * 1000)

  setDate: (date) ->
    @currentDate = date
    # console.log "set date to", Util.dateString @currentDate

  getPoem: (id, next) ->
    dateKey = @reverseMapping[id]

    if not id
      return next last: yes
    if @poemsCache.has dateKey
      return next @poemsCache.get dateKey

    $.getJSON "poems/#{id}.json", (res) =>
      poem = new Poems.Poem(res)
      @poemsCache.set dateKey, poem
      next poem

  getPoemForDate: (date, next) ->
    dateKey = Util.dateString date
    id = @mapping[dateKey]
    @getPoem id, next

  loadMapping: (next) ->
    $.getJSON "poems/summary.json", (res) =>
      @mapping = res.mapping
      @reverseMapping = _.invert(@mapping)
      @descriptors = res.items

      allDates = Object.keys(@mapping)
      @firstDate = new Date allDates[0]
      @lastDate = new Date allDates[allDates.length - 1]

      next()

  like: (poemId) ->
    if @likes.has(poemId) then @likes.delete(poemId) else @likes.add(poemId)
    localStorage.likes = JSON.stringify Array.from @likes

  getFavorites: (next) ->
    poemIds = (id for id in Array.from @likes)

    return next() if poemIds.length is 0

    poems = []
    count = 0
    done = -> ++count == poemIds.length && next && next(poems)
    for id in poemIds
      @getPoem id, (poem) ->
        poems.push(poem)
        done()

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

class Poems.Poem
  constructor: (data) ->
    this[prop] = value for prop, value of data
    this.url = "#poems/#{@id}"

  heading: ->
    @title || @firstLine

  like: ->
    Model.like(@id)

  isLiked: ->
    Model.likes.has(@id)

  date: ->
    new Date Model.reverseMapping[@id]
