Template.settings.rendered = ->
  @autorun _.bind ->
    Deps.afterFlush ->

  , this
