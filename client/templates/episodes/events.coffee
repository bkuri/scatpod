Template.episodes.events
  'click a': (event) ->
    event.preventDefault()

  'click a.queue': (event) ->
    $a = $(event.target).addClass 'disabled'

    Meteor.call 'episodeAdd', $a.data(), (error, response) ->
      $(event.target).removeClass 'disabled'
      return if error?

      $a
        .removeClass('queue').addClass('queued').next('i')
        .removeClass('mdi-content-add white-text').addClass 'mdi-content-remove black-text'

  'click a.queued': (event) ->
    $a = $(event.target).addClass 'disabled'

    Meteor.call 'episodeRemove', $a.data(), (error, response) ->
      $(event.target).removeClass 'disabled'
      return if error?

      $a
        .removeClass('queued').addClass('queue').next('i')
        .removeClass('mdi-content-remove black-text').addClass 'mdi-content-add white-text'
