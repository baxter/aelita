class ButtonBoard
  constructor: (elem, size) ->
    @container = document.createElement("div")
    elem.appendChild(@container)
    @container.classList.add("buttonBoard")
    @container.appendChild(@makeRow(row, size)) for row in [1..size]

  makeRow: (row, size) ->
    div = document.createElement("div")
    div.appendChild(@makeButton(column, row)) for column in [1..size]
    div

  makeButton: (elem, column, row) ->
    div = document.createElement("div")
    div.addEventListener("click", @onClick.bind(self, column, row))
    div

  onClick: (column, row) ->
    @emit("buttonDown", [column, row])
    @emit("buttonUp", [column, row])

  setLightStates: (matrixOfLights) ->
    for row, rowNumber in matrixOfLights
      do(row, rowNumber) ->
        @setLightState([rowNumber, columnNumber], lightState) for lightState,columnNumber in row

  setLightState: ([row, column], lightState) ->
    button = $(">:nth-child(#{row})>:nth-child(#{column})", @container)
    if lightState
      button.classList.add("lit")
    else
      button.classList.remove("lit")

  on: (eventName, listener) ->
    @listeners[eventName].push(listener)

  emit: (eventName, others...) ->
    listener(others) for listener in @listeners

window.ButtonBoard = ButtonBoard

