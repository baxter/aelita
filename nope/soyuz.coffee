size = 16

bb = new window.ButtonBoard(document.body, size)
scale = new window.PentatonicScale()

onNotes = {};

activeColumn = size # This is unintuitive but the tick will set the 2nd column to be active if the activeColumn is set to 1

tick = ->
  for row in [1..size]
    do (row) ->
      if !buttonActive([activeColumn, row])
        bb.setLightState([activeColumn, row], false)
  activeColumn = (activeColumn % size ) + 1
  for row in [1..size]
    do (row) ->
      bb.setLightState([activeColumn, row], true)
      if buttonActive([activeColumn, row])
        playNote(gainNodes[--row], 0.3)

buttonActive = (point) ->
  pointString = point.toString()
  onNotes[pointString]

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

bb.on "buttonDown", (point) ->
  if buttonActive(point)
    onNotes[point.toString()] = false
    if activeColumn != point[0]
      bb.setLightState(point, false)
  else
    onNotes[point.toString()] = true
    bb.setLightState(point, true)

setInterval tick, 300
