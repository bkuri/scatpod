Template.details.rendered = ->
  @autorun _.bind ->
    Deps.afterFlush ->
      $('body')
        .on 'loaded', (event, main, complement='#fff') ->

          # console.log main, backgroundColor
          $(@)
            .off 'loaded'
            .theme main, complement

          Meteor.setTimeout ->
            $('#details').css backgroundColor: 'rgba(34,34,34,0)'
          , 1000
        .bokeh hue: (Session.get 'podcast').img, img: '#thumb'

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
