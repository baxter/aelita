class ButtonBoard
  constructor: (elem, size) ->
    @listeners = {}
    @container = document.createElement("div")
    elem.appendChild(@container)
    @container.classList.add("buttonBoard")
    @container.appendChild(@makeRow(row, size)) for row in [1..size]

  makeRow: (row, size) ->
    div = document.createElement("div")
    div.appendChild(@makeButton(column, row)) for column in [1..size]
    div

  makeButton: (column, row) ->
    div = document.createElement("div")
    div.addEventListener("mousedown", @emit.bind(this, "buttonDown", [column, row]))
    div.addEventListener("mouseup", @emit.bind(this, "buttonUp", [column, row]))
    div

  setLightStates: (matrixOfLights) ->
    for row, rowNumber in matrixOfLights
      do(row, rowNumber) ->
        @setLightState([rowNumber, columnNumber], lightState) for lightState,columnNumber in row

  setLightState: (point, lightState) ->
    button = @_getButton(point)
    if lightState
      button.classList.add("lit")
    else
      button.classList.remove("lit")

  getLightStates: ->
    for row, rowNumber in @container.children
      do(row, rowNumber) =>
        @getLightState([rowNumber + 1, columnNumber + 1]) for lightState, columnNumber in row.children

  getLightState: (point) ->
    button = @_getButton(point)
    button.classList.contains("lit")

  _getButton: (point) ->
    [column, row] = point
    @container.children[--row].children[--column]

  on: (eventName, listener) ->
    @listeners[eventName] ||= []
    @listeners[eventName].push(listener)

  emit: (eventName, others...) ->
    @listeners[eventName] ||= []
    listener.apply(null, others) for listener in @listeners[eventName]

window.ButtonBoard = ButtonBoard

