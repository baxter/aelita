size = 16

bb = new window.ButtonBoard(document.body, size)
scale = new window.PentatonicScale()

activeColumn = size # This is unintuitive but the tick will set the 2nd column to be active if the activeColumn is set to 1

tick = ->
  for row in [1..size]
    btn = bb._getButton activeColumn, row
    bb.setLightState(btn, false) unless btn._aelita.on
  activeColumn = (activeColumn % size ) + 1
  for row in [1..size]
    btn = bb._getButton activeColumn, row
    bb.setLightState(btn, true)
    playNote(gainNodes[row - 1], 0.3) if btn._aelita.on

playNote = (gainNode, duration) ->
  gainNode.gain.setValueAtTime(0, context.currentTime)
  gainNode.gain.linearRampToValueAtTime(0.5, context.currentTime + duration * 0.3)

  setTimeout( () ->
    gainNode.gain.setValueAtTime(0.5, context.currentTime)
    gainNode.gain.linearRampToValueAtTime(0, context.currentTime + duration * 0.3)
  , (duration * 0.4) * 1000)

context = new webkitAudioContext()

gainNodes = for freq in scale.frequencies(size).reverse()
  do (freq) ->
    osc = context.createOscillator()
    osc.frequency.value = freq
    gainNode = context.createGainNode()
    gainNode.gain.value = 0
    osc.connect(gainNode)
    osc.start(0)
    gainNode.connect(context.destination)
    gainNode

bb.on "buttonDown", (button) ->
  if button._aelita.on
    button._aelita.on = false
    if activeColumn != button._aelita.column
      bb.setLightState(button, false)
  else
    button._aelita.on = true
    bb.setLightState(button, true)
  window.location.hash = bb.getEncodedLights()

bb.initaliseLights window.location.hash.substring 1 if window.location.hash

setInterval tick, 300
