Template.details.created = ->
  @level = new ReactiveVar 1


Template.details.rendered = ->
  $deets = $('#details')
  $toolbar = $('.container-fluid', '#details')

  $toolbar.pushpin offset: $toolbar.offset().top, top: $toolbar.offset().top
  $('.collapsible').collapsible()

  @autorun _.bind ->
    Deps.afterFlush ->
      window.toTheTop ->
        window.refreshListItems()
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
