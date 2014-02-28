class PentatonicScale
  constructor: ->
    @base_frequency = 220
    @ratios = [
      1/1,
      32/27,
      4/3,
      3/2,
      16/9
    ]

  frequencies: (number=10) ->
    for i in [0..number-1]
      @ratio(i)

  ratio: (i) ->
    div = Math.floor(i / @ratios.length) + 1
    mod = i % @ratios.length
    @ratios[mod] * (@base_frequency * div)

window.PentatonicScale = PentatonicScale