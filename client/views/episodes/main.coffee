Template.details.rendered = ->
  $deets = $('#details')

  @autorun _.bind ->
    Deps.afterFlush ->
      $('.collapsible').collapsible()
      $toolbar = $('.container-fluid', '#details').css backgroundColor: document.body.style.backgroundColor
      $toolbar.pushpin offset: $toolbar.offset().top, top: $toolbar.offset().top

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
