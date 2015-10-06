determineEmail = (user) ->
  return switch
    when user.services?
      services = (_.keys user.services)

      if ('facebook' in services) then user.services.facebook.email
      else if ('google' in services) then user.services.google.email
      else null

    when user.emails? then user.emails[0].address
    else null


Accounts.onCreateUser (options, user) ->
  data =
    email: (determineEmail user)
    name: options.profile?.name or ''

  if data.email? then Meteor.call 'emailSend', data, (error) ->
    (console.error error) if error?

  profile = playlist: 'main', playlists: [name: 'main', tracks: []], podcasts: [], settings: {}
  profile = (_.extend profile, options.profile) if options.profile?
  _.extend user, {profile}


Meteor.publish 'details', (url) ->
  check url, String

  Meteor.call 'getFeed', (decodeURIComponent url), (error, result) =>
    if result?
      result.item = (_.take result.item, 50)
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


Meteor.publish 'userData', ->
  _id = @userId
  return @ready() unless _id?

  Meteor.users.find {_id},
    fields:
      'services.facebook.email': 1
      'services.google.email': 1
      'services.twitter.screenName': 1
      'emails.address[0]': 1
      'profile': 1


SSR.compileTemplate 'welcome', (Assets.getText 'templates/welcome.html')
