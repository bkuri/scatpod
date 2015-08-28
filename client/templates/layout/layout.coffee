Template.layout.rendered = ->
  $('.button-collapse').sideNav()
  $('.modal-trigger').leanModal()
  $('.parallax').parallax()
  $('.tooltipped').tooltip delay: 50

  # FIXME should work but doesn't...
  $(':input:visible[autofocus]').first().focus()
