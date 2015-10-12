# generate blurred backgrounds using a list of colors
# heavily tweaked version of jabahar/bokehBg + StackBlur

(($) ->
  process = (canvas, options) ->
    context = (canvas.getContext '2d')
    maxRadius = options.maxRadius or Math.min(canvas.width, canvas.height) / 2
    minRadius = options.minRadius or (maxRadius / 2)
    opts = $.extend({minRadius, maxRadius}, $.fn.bokeh.defaults, options)
    total = unless opts.total? then Math.round((canvas.width * canvas.height) / 30000) else opts.total

    context.fillStyle = chroma(opts.colors[0]).css()
    context.fillRect 0, 0, canvas.width, canvas.height
    (console.log total, opts.minRadius, opts.maxRadius, opts.colors) if opts.log


    if (chroma(opts.base).luminance() < 0.4)
      opts.colors
        .sort (a, b) -> (chroma(a).luminance() > chroma(b).luminance())
        .map (c, i) -> opts.colors[i] = (chroma(c).luminance 0.1)

    else
      opts.colors.sort (a, b) -> (chroma(a).luminance() < chroma(b).luminance())

    for color in opts.colors
      context.beginPath()

      x = Math.floor(Math.random() * canvas.width)
      y = Math.floor(Math.random() * canvas.height)
      r = Math.floor(Math.random() * (opts.maxRadius - opts.minRadius)) + opts.minRadius

      context.fillStyle = chroma(color).luminance(0.4).css()
      context.arc x, y, r, 0, (Math.PI * 2), yes
      context.fill()

    try
      (StackBlur.canvasRGB canvas, 0, 0, canvas.width, canvas.height, opts.blur) if canvas? and (opts.blur? > 0)
      'background-image': "url(#{canvas.toDataURL()})"

    catch error
      console.error error
      'background-color': chroma(opts.colors[0]).css()


  $.fn.bokeh = (options={}) ->
    $me = $(@).data base: options.base, colors: options.colors
    canvas = (document.createElement 'canvas')
    canvas.height = document.documentElement.clientHeight
    canvas.width = document.documentElement.clientWidth

    $me
      .css process canvas, options
      .trigger 'loaded'

    return $me


  $.fn.bokeh.defaults =
    base: 0x222
    blur: 100
    colors: [0x666]
    log: no


  return
) jQuery
