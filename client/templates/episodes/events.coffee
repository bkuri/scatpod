Template.details.events
  'click a.btn-large': (event) ->
    event.preventDefault()
    history.back()


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
