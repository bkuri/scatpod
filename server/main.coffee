Accounts.onCreateUser (options, user) ->
  _.extend user, profile: playlists: [name: 'main', tracks: []], podcasts: []
