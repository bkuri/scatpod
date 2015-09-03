Template.layout.events
  'click #fab a': (event, template) ->
    event.preventDefault()

  'click #fab .skip.f': (event, template) ->
    playlist = (Session.get 'playlist')
    playlist.setTime playlist.getTime() + 20

  'click #fab .skip.r': (event, template) ->
    playlist = (Session.get 'playlist')
    playlist.setTime playlist.getTime() - 10

  'click #fab .toggle': (event, template) ->
    (Session.get 'playlist').togglePlay()
