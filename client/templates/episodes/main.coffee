Template.details.rendered = ->
  @autorun _.bind ->
    template = Template.instance()

    Deps.afterFlush ->
      $('#details').bokeh()
      $('.collapsible').collapsible()

  , this


getQueued = ->
  console.log 'getQueued()'
  {profile} = Meteor.user()
  (_.findWhere profile.playlists, name: profile.playlist).tracks


Template.episodes.created = ->
  @queued = -> (_.pluck getQueued(), 'url')

###
Template.episodes.rendered = ->
  @autorun _.bind ->
    template = Template.instance()

    Deps.afterFlush ->

  , this
###
