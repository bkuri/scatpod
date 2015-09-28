$.fn.process = (out=no, callback=null) ->
  $(@)
    .toggleClass 'new', out

    .filter (index) ->
      rc = @getBoundingClientRect()
      outside = (rc.bottom < 0) or (rc.top > window.innerHeight)
      # console.log "##{index} outside: #{outside}\t(top: #{rc.top}, bottom: #{rc.bottom})"
      not outside

    .velocity switch
      when out then p: 'transition.slideDownBigOut', o: backwards: yes, complete: callback, stagger: 75
      else p: 'transition.slideUpIn', o: complete: callback, stagger: 150


$.fn.scrollToView = ->
  $me = $(@)
  $me.velocity axis: 'x', container: ($me.parents 'div.container')
