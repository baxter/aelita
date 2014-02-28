bb = new window.ButtonBoard(document.body, 8)



bb.on("buttonDown", (point) ->
  bb.setLightState(point, true);
)

bb.on("buttonUp", (point) ->
  bb.setLightState(point, false);
)

