bb = new window.ButtonBoard(document.body, 8)



bb.on("buttonDown", (button) ->
  button.setLightState true
)

bb.on("buttonUp", (button) ->
  button.setLightState false
)

