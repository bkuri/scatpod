# bokeh
# heavily tweaked version of jabahar/bokehBg + StackBlur

(($) ->
  canvas = (document.createElement 'canvas')

  $.fn.bokeh = (options={}) ->
    $me = $(@)
    canvas.width = parseInt $me.width()
    canvas.height = parseInt $me.height()
    context = (canvas.getContext '2d')
    hue = (Math.random() * 240)

    maxRadius = options.maxRadius or Math.min(canvas.width, canvas.height) / 5
    minRadius = options.minRadius or (maxRadius / 2)
    opts = $.extend({minRadius, maxRadius}, $.fn.bokeh.defaults, options)
    total = unless opts.total? then Math.round((canvas.width * canvas.height) / 30000) else opts.total

    context.fillStyle = opts.bgColor
    context.fillRect 0, 0, canvas.width, canvas.height
    (console.log total, minRadius, maxRadius, hue) if opts.log

    for i in [0..total]
      context.beginPath()

      h = hue + (Math.random() * 120)
      s = 20 + (Math.random() * 60)
      l = 10 + (Math.random() * 40)
      a = 0.25 + (Math.random() * 0.55)

      context.fillStyle = "hsla(#{h}, #{s}%, #{l}%, #{a})"

      x = Math.floor(Math.random() * canvas.width)
      y = Math.floor(Math.random() * canvas.height)
      r = Math.floor(Math.random() * (opts.maxRadius - opts.minRadius)) + opts.minRadius

      context.arc x, y, r, 0, (Math.PI * 2), yes
      context.fill()

    (StackBlur.canvasRGB canvas, 0, 0, canvas.width, canvas.height, opts.blur) if (opts.blur? > 0)
    $me.css 'background-image': "url(#{canvas.toDataURL()})"
    return

  $.fn.bokeh.defaults =
    bgColor: '#222'
    blur: 100
    log: yes

  return
) jQuery
