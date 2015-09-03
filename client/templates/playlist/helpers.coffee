Template.playlist.helpers
  items: ->
    filter = switch
      when (Session.get 'hidePlayed') then played: $ne: true
      else {}

    Playlist.find filter, createdAt: -1

  hidePlayed: ->
    Session.get 'hidePlayed'

  unplayedCount: ->
    (Playlist.find played: $ne: true).count()
