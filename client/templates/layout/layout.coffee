Template.layout.rendered = ->
  @autorun _.bind ->
    Deps.afterFlush ->
      $('.button-collapse').sideNav()
      $('.dropdown-button').dropdown belowOrigin:true, hover: true
      $('.modal-trigger').leanModal()
      $('.parallax').parallax()

      # FIXME should work but doesn't...
      $(':input:visible[autofocus]').first().focus()
  , this
