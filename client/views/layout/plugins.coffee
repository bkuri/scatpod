# get average color from a valid image selector
# see http://stackoverflow.com/a/2541680/4305736
$.fn.setColorFrom = (sel, src) ->
  return $(@).css backgroundColor: '#000' unless sel?

  img = (document.querySelector sel)
  canvas = (document.createElement 'canvas')
  context = (canvas.getContext '2d')

  img.onload = ->
    canvas.height = img.naturalHeight or img.offsetHeight or img.height
    canvas.width = img.naturalWidth or img.offsetWidth or img.width

    try
      context.drawImage img, 0, 0
      data = (context.getImageData 0, 0, canvas.width, canvas.height)

    catch error
      console.error error
      return null

    blockSize = 5
    count = 0
    i = -4
    [r, g, b] = [0, 0, 0]

    while (i += blockSize * 4) < data.data.length
      ++count
      r += data.data[i]
      g += data.data[i + 1]
      b += data.data[i + 2]

    color = chroma.rgb (r // count), (g // count), (b // count)

    console.log color.css()

    $(document.body)
      .css backgroundColor: color.luminance(0.02).css()
      .find 'ul.collection > li.collection-item'
      .css backgroundColor: color.luminance(0.01).css()

    img.removeEventListener 'load'

  # see https://coderwall.com/p/pa-2uw/using-external-images-with-canvas-getimagedata-and-todataurl
  # img.crossOrigin = ''
  img.src = src
  return $(@)


$.fn.fillWith = (text, isInput=no) ->
  $me = $(@)

  return $me unless text.length
  s = 1

  iid = setInterval ->
    if s < text.length then s++
    else clearInterval iid

    if isInput then ($me.val text.substr 0, s)
    else ($me.text text.substr 0, s)
  , 0

  return $me


$.fn.hideQuery = ->
  $input = ($(@).find 'input')
  text = $input.text()

  restore = ->
    $(@).addClass 'hide'
    $('#brand').removeClass 'hide'

  restore() unless text.length

  iid = setInterval ->
    if text.length
      text = text.substr 0, (text.length - 1)
      $input.text text

    else
      clearInterval iid
      Meteor.setTimeout restore, 200
  , 0


$.fn.reset = ->
  $(@)
    .removeClass 'searching'
    .find('span.term').removeClass('hide')


# retrieve split complementary colors
$.fn.splitColors = (color, offset=30) ->
  hue = (chroma.get 'hsl.h', color)

  [
    chroma.set 'hsl.h', (hue + (180 - offset)) % 360
    chroma.set 'hsl.h', (hue + (180 + offset)) % 360
  ]


$.fn.theme = (color1, color2) ->
  $(@)
    #.find('.label:not(.red)').css(backgroundColor: color2).end()
    .find('.queue').css(borderColor: "transparent #{color2} transparent transparent").end()
    # .find('.mdi-content-add').css color: color1
    .end()
