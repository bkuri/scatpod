# bokeh
# heavily tweaked version of jabahar/bokehBg + StackBlur

(($) ->
  # get average color from an image
  # see http://stackoverflow.com/a/2541680/4305736
  average = (img) ->
    buffer = (document.createElement 'canvas')
    context = (buffer.getContext '2d')
    # return null unless context?

    buffer.height = img.naturalHeight or img.offsetHeight or img.height
    buffer.width = img.naturalWidth or img.offsetWidth or img.width

    try
      context.drawImage img, 0, 0
      data = (context.getImageData 0, 0, buffer.width, buffer.height)

    catch error
      console.error error
      return null

    blockSize = 5
    count = 0
    i = -4
    rgb = [0, 0, 0]

    while (i += blockSize * 4) < data.data.length
      ++count
      rgb[0] += data.data[i]
      rgb[1] += data.data[i + 1]
      rgb[2] += data.data[i + 2]

    rgb[0] //= count
    rgb[1] //= count
    rgb[2] //= count

    # console.log "average (RGB) -> #{rgb}"
    return rgb

  # retrieve complementary color in hex
  # see http://stackoverflow.com/questions/1664140/js-function-to-calculate-complementary-colour#comment36960839_21924155
  complement = (color) ->
    ('000000' + (('0xffffff' ^ "0x#{color}").toString(16))).slice(-6)


  # convert rgb values to hex
  # see http://stackoverflow.com/a/31464903/4305736
  hex = (rgb) ->
    ('00000' + (rgb[0] << 16 | rgb[1] << 8 | rgb[2]).toString(16)).slice(-6)


  # convert rgb values to hsl
  # see https://gmigdos.wordpress.com/2011/01/13/javascript-convert-rgb-values-to-hsl/
  hsl = (rgb) ->
    r = (rgb[0] / 255)
    g = (rgb[1] / 255)
    b = (rgb[2] / 255)

    maxC = (Math.max r, g, b)
    minC = (Math.min r, g, b)

    h = 0
    s = 0
    l = (maxC + minC) / 2

    unless maxC is minC
      diff = (maxC - minC)

      h = switch
        when (r is maxC) then (g - b) / diff
        when (g is maxC) then 2.0 + (b - r) / diff
        else 4.0 + (r - g) / diff

      s = switch
        when (l < 0.5) then diff / (maxC + minC)
        else diff / (2.0 - diff)

    h *= 60
    s *= 100
    l *= 100

    (h += 360) if (h < 0)

    value = [
      Math.floor h
      Math.floor s
      Math.floor l
    ]

    # console.log "average (HSL) -> #{value}"
    return value


  process = (canvas, options, hue) ->
    context = (canvas.getContext '2d')
    maxRadius = options.maxRadius or Math.min(canvas.width, canvas.height) / 2
    minRadius = options.minRadius or (maxRadius / 2)
    opts = $.extend({hue, minRadius, maxRadius}, $.fn.bokeh.defaults, options)
    total = unless opts.total? then Math.round((canvas.width * canvas.height) / 30000) else opts.total

    context.fillStyle = opts.bg
    context.fillRect 0, 0, canvas.width, canvas.height
    (console.log total, opts.minRadius, opts.maxRadius, hue) if opts.log

    for i in [0..total]
      context.beginPath()

      # h = hue + (Math.random() * 120)
      s = 20 + (Math.random() * 60)
      l = 10 + (Math.random() * 40)
      a = 0.25 + (Math.random() * 0.55)

      context.fillStyle = "hsla(#{hue}, #{s}%, #{l}%, #{a})"

      x = Math.floor(Math.random() * canvas.width)
      y = Math.floor(Math.random() * canvas.height)
      r = Math.floor(Math.random() * (opts.maxRadius - opts.minRadius)) + opts.minRadius

      context.arc x, y, r, 0, (Math.PI * 2), yes
      context.fill()

    try
      (StackBlur.canvasRGB canvas, 0, 0, canvas.width, canvas.height, opts.blur) if canvas? and (opts.blur? > 0)
      'background-image': "url(#{canvas.toDataURL()})"

    catch error
      console.error error
      'background-color': "hsl(#{hue}%, 15%, 20%)"


  $.fn.bokeh = (options={}) ->
    $me = $(@)
    canvas = (document.createElement 'canvas')
    canvas.height = document.documentElement.clientHeight # parseInt $me.height()
    canvas.width = document.documentElement.clientWidth # parseInt $me.width()

    if (_.isString options.hue)
      img = (document.querySelector options.img) or new Image()

      img.onload = (e) ->
        avg = (average img)
        color = ["##{hex avg}", "##{complement hex avg}"]

        $me
          .css process canvas, options, (hsl avg)?[0] or (Math.random() * 240)
          .trigger 'loaded', color

      # see https://coderwall.com/p/pa-2uw/using-external-images-with-canvas-getimagedata-and-todataurl
      img.crossOrigin = ''
      img.src = options.hue

    else
      $me
        .css process canvas, options, (Math.random() * 240)
        .trigger 'loaded'

    return $me


  $.fn.bokeh.defaults =
    bg: '#222'
    blur: 50
    log: no
    total: 5


  return
) jQuery
