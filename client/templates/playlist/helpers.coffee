Template.playlist.helpers
  items: ->
    filter = switch
      when (Session.get 'hidePlayed') then played: $ne: yes
      else {}

    Playlist.find filter, createdAt: -1

  hidePlayed: ->
    Session.get 'hidePlayed'

  unplayedCount: ->
    (Playlist.find played: $ne: yes).count()
