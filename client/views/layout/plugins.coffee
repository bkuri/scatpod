$.fn.colorize = (backgroundColor) ->
  $(@)
    .removeClass 'negative positive'
    .addClass (window.getThemeClass backgroundColor)
    .css {backgroundColor}
