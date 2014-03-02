class ButtonBoard
  constructor: (elem, @size) ->
    @listeners = {}
    @buttons = new Array @size * @size
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
    idx = @_getButtonIndex column, row
    div.addEventListener("mousedown", @emit.bind(this, "buttonDown", div))
    div.addEventListener("mouseup", @emit.bind(this, "buttonUp", div))
    div._aelita = on: false, idx: idx, row: row, column: column
    @buttons[idx] = div
    div

  getEncodedLights: ->
    @buttons.reduce (encoded, div) ->
      encoded += if div._aelita.on then 1 else 0
    , ""

  initaliseLights: (encodedLightStr) ->
    for l, i in encodedLightStr.split ""
      btn = @buttons[(i % @size) + Math.floor(i / @size) * @size]
      if l == "1"
        btn._aelita.on = true
        btn.classList.add "lit"
      else
        btn._aelita.on = false
        btn.classList.remove "lit"
    true

  setLightStates: (matrixOfLights) ->
    for row, rowNumber in matrixOfLights
      do(row, rowNumber) ->
        @setLightState([rowNumber, columnNumber], lightState) for lightState,columnNumber in row

  setLightState: (button, lightState) ->
    if lightState
      button.classList.add("lit")
    else
      button.classList.remove("lit")

  getLightState: (button) ->
    button.classList.contains("lit")

  _getButton: (column, row) ->
    @buttons[@_getButtonIndex column, row]

  _getButtonIndex: (column, row) ->
    --column + --row * @size

  on: (eventName, listener) ->
    @listeners[eventName] ||= []
    @listeners[eventName].push(listener)

  emit: (eventName, others...) ->
    @listeners[eventName] ||= []
    listener.apply(null, others) for listener in @listeners[eventName]

window.ButtonBoard = ButtonBoard

