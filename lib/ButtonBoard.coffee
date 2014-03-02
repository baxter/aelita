class Button
  constructor: (@elem, @column, @row) ->
    @on = false
  setLightState: (lightState) ->
    action = if lightState then "add" else "remove"
    @elem.classList[action] "lit"
  getLightState: ->
    @elem.classList.contains "lit"

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
    button = new Button(div, column, row)
    div.addEventListener("mousedown", @emit.bind(this, "buttonDown", button))
    div.addEventListener("mouseup", @emit.bind(this, "buttonUp", button))
    @buttons[@getButtonIndex column, row] = button
    div

  getEncodedLights: ->
    @buttons.reduce (encoded, button) ->
      encoded += if button.on then 1 else 0
    , ""

  initaliseLights: (encodedLightStr) ->
    for l, i in encodedLightStr.split ""
      button = @buttons[(i % @size) + Math.floor(i / @size) * @size]
      if l == "1"
        button.on = true
        button.elem.classList.add "lit"
      else
        button.on = false
        button.elem.classList.remove "lit"
    true

  setLightStates: (matrixOfLights) ->
    for row, rowNumber in matrixOfLights
      do(row, rowNumber) ->
        @setLightState([rowNumber, columnNumber], lightState) for lightState,columnNumber in row

  getButton: (column, row) ->
    @buttons[@getButtonIndex column, row]

  getButtonIndex: (column, row) ->
    --column + --row * @size

  on: (eventName, listener) ->
    @listeners[eventName] ||= []
    @listeners[eventName].push(listener)

  emit: (eventName, others...) ->
    @listeners[eventName] ||= []
    listener.apply(null, others) for listener in @listeners[eventName]

window.ButtonBoard = ButtonBoard

