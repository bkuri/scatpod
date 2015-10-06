Template.details.rendered = ->
  $deets = $('#details')

  @autorun _.bind ->
    Deps.afterFlush ->
      $(document.body)
        .on 'loaded', (event, main, complement='#fff') ->

          # console.log main, backgroundColor
          $(@)
            .off 'loaded'
            .theme main, complement

        .setColorFrom '#thumb', (Session.get 'podcast').img

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
