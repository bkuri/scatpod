Template.details.events
  'click a': (event) ->
    event.preventDefault()
    $(event.currentTarget).addClass 'disabled'


  'click a.btn-back': (event) ->
    history.back()


  'click a.btn-leave': (event) ->
    {cid} = (Session.get 'podcast')

    unless cid in (Session.get 'tracking')
      Materialize.toast 'Podcast not found in tracking list', 1000
      return

    Meteor.call 'podcastRemove', cid, (error, response) ->
      $(event.currentTarget).removeClass 'disabled'
      return if error?

      Meteor.setTimeout ->
        Session.set 'tracking', (_.pluck Meteor.user().profile.podcasts, '_id')
        Materialize.toast 'Unsubscribed from podcast', 1000
      , 300


  'click a.btn-join': (event) ->
    data = (Session.get 'podcast')
    meta = (Details.findOne Router.current().params.url)
    meta = (_.omit meta, ['description', 'info', 'link', 'owner'])
    data = _.extend data, {meta}

    Meteor.call 'podcastAdd', data, (error, response) ->
      $(event.currentTarget).removeClass 'disabled'
      return if error?

      Meteor.setTimeout ->
        Session.set 'tracking', (_.pluck Meteor.user().profile.podcasts, '_id')
        Materialize.toast 'Subscribed to podcast', 1000
      , 300


Template.episodes.events
  'click a': (event) ->
    event.preventDefault()


  'click a.load-more': (event, template) ->
    template.limit.set template.limit.get() + 24


  'click a.queue': (event) ->
    $a = $(event.target).addClass 'disabled'

    Meteor.call 'episodeAdd', (_.extend $a.data(), parent: (Session.get 'podcast').cid), (error) ->
      $a.removeClass 'disabled'
      return if error?

      $a
        .removeClass('queue').addClass('queued').next('i')
        .removeClass('mdi-content-add white-text').addClass 'mdi-content-remove black-text'

      # $('a:not(.r)', '#fab').removeClass 'disabled'


  'click a.queued': (event) ->
    $a = $(event.target).addClass 'disabled'
    data = $a.data()

    Meteor.call 'episodeRemove', data, (error, response) ->
      $a.removeClass 'disabled'
      return if error?

      $a
        .removeClass('queued').addClass('queue').next('i')
        .removeClass('mdi-content-remove black-text').addClass 'mdi-content-add white-text'
