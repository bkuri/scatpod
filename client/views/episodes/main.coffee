Template.details.rendered = ->
  $deets = $('#details')

  @autorun _.bind ->
    Deps.afterFlush ->
      $('.collapsible').collapsible()

  , this


getQueued = ->
  console.log 'getQueued()'
  {profile} = Meteor.user()
  (_.findWhere profile.playlists, name: profile.playlist).tracks


Template.episodeList.created = ->
  @queued = -> (_.pluck getQueued(), 'url')

###
Template.episodeList.rendered = ->
  @autorun _.bind ->
    template = Template.instance()

    Deps.afterFlush ->

  , this
###
