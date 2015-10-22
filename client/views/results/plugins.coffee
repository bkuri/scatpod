$.fn.onlyVisible = (reverse=no) ->
  $(@).filter (index) ->
    bounds = @getBoundingClientRect()
    outside = (bounds.bottom < 56) or (bounds.top > window.innerHeight)
    if reverse then outside else (not outside)


$.fn.process = (out=no, callback=null) ->
  $(@)
    .toggleClass 'new', out
    .onlyVisible()
    .velocity p: 'transition.fadeIn', o: complete: callback, stagger: 150


$.fn.scrollToView = ->
  $me = $(@)
  $me.velocity axis: 'x', container: ($me.parents 'div.container')
