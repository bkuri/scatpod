Template.playlist.events
  'change .hide-played input': (event) ->
    Session.set 'hidePlayed', event.target.checked
