$.fn.colorize = (color) ->
  $(@)
    .removeClass 'negative positive'
    .addClass (window.getThemeClass color)
    .css backgroundColor: color


$.fn.fillWith = (text, isInput=no) ->
  $me = $(@)

  return $me unless text.length
  s = 1

  iid = setInterval ->
    if (s < text.length) then s++
    else (clearInterval iid)

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
