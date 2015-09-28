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


$.fn.theme = (color1, color2) ->
  $(@)
    #.find('.label:not(.red)').css(backgroundColor: color2).end()
    .find('.queue').css(borderColor: "transparent #{color2} transparent transparent").end()
    # .find('.mdi-content-add').css color: color1
    .end()
