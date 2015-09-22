Accounts.onCreateUser (options, user) ->
  _.extend user, profile: playlist: 'main', playlists: [name: 'main', tracks: []], podcasts: [], settings: {}


Meteor.publish 'details', (url) ->
  check url, String

  Meteor.call 'getFeed', (decodeURIComponent url), (error, result) =>
    if result?
      @added 'details', url, result
      @ready()
    else @ready()


Meteor.publish 'search', (term) ->
  check term, String

  Meteor.call 'podcastSearch', term, (error, result) =>
    if result?
      @added 'search', term, result.results
      @ready()
    else @ready()
