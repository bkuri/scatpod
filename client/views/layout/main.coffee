Template.layout.created = ->
  @searching = new ReactiveVar no


Template.layout.rendered = ->
  @autorun _.bind ->
    Deps.afterFlush ->
      $('.button-collapse').sideNav()
      $('.dropdown-button').dropdown belowOrigin:yes, hover: yes
      $('.modal-trigger').leanModal()
      $('.parallax').parallax()

      $li = $('li.search', 'body > .navbar-fixed')
      $li.data width: "#{$li.width()}px"

      # FIXME should work but doesn't...
      # $(':input:visible[autofocus]').first().focus()
  , this
