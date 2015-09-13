Accounts.onCreateUser (options, user) ->
  _.extend user, profile: playlist: 'main', playlists: [name: 'main', tracks: []], podcasts: [], settings: {}
