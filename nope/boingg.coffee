size = 8

bb = new window.ButtonBoard(document.body, size)

bounceHeights =
  0 for x in [1..size]

currentHeights =
  0 for x in [1..size]

currentDirections =
  false for x in [1..size] # true for upward

setInterval(() ->
  for column in [1..size]
    do (column) ->
      if bounceHeights[column] > 0
        bb.setLightState([column, currentHeights[column]], false)
        if currentDirections[column]
          currentHeights[column] += 1
        else
          currentHeights[column] -= 1

        if currentHeights[column] > bounceHeights[column]
          currentHeights[column] -= 2
          currentDirections[column] = false
        if currentHeights[column] == 0
          currentHeights[column] = 2
          currentDirections[column] = true
        bb.setLightState([column, currentHeights[column]], true)
        if(currentHeights[column] == 1)
          playNote(gainNodes[--column], 0.3)
, 300)

playNote = (gainNode, duration) ->
  gainNode.gain.setValueAtTime(0, context.currentTime)
  gainNode.gain.linearRampToValueAtTime(0.5, context.currentTime + duration * 0.3)

  setTimeout( () ->
    gainNode.gain.setValueAtTime(0.5, context.currentTime)
    gainNode.gain.linearRampToValueAtTime(0, context.currentTime + duration * 0.3)
  , (duration * 0.4) * 1000)

context = new webkitAudioContext()

freqs = [261.626, 293.665, 329.628, 391.995, 440, 523.25, 587.33, 659.25]
gainNodes = for freq in freqs
  do (freq) ->
    osc = context.createOscillator()
    osc.frequency.value = freq
    gainNode = context.createGainNode()
    gainNode.gain.value = 0
    osc.connect(gainNode)
    osc.start(0)
    gainNode.connect(context.destination)
    gainNode

bb.on("buttonDown", (point) ->
  [column, row] = point
  if row > 1
    bounceHeights[column] = row
    currentHeights[column] = row
  else
    bounceHeights[column] = 0
    currentHeights[column] = 0
    bb.setLightState([column, row], false) for row in [1..size]
)


