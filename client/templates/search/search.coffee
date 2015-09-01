Template.search.rendered = ->
  # remove invalid images
  $('img', '.masonry-container')
    .on('error', -> $(@).remove())
    .filter(-> $(@).is 'img:not([src])')
    .remove()
