Template.search.events
  'click span.tools > a': (event) ->
    $a = $(event.target).parent()
    data = ($a.parents '.card').data()

    event.preventDefault()
    event.stopPropagation()

    if ($a.hasClass 'list')
      Session.set 'podcast', cid: data.id, list: (_.head data.meta.item, 10), name: data.meta.title
      $('#episodes').openModal()

    else if ($a.hasClass 'play')
      track = (_.sample data.meta.item)
      # console.log 'play', JSON.stringify item
      s = new buzz.sound track.enclosure.$.url

      $a.addClass 'disabled'
      sound.stop() for sound in buzz.sounds

      if 'duration' in (Object.keys track)
        timer = (buzz.fromTimer track.duration)
        timeout = switch
          when timer > 0 then (timer * 1000) - (90 * 1000)
          else (90 * 1000)

        s.setTime(90).setVolume(0).fadeTo 80, 10000

      else
        timeout = (90 * 1000)
        s.fadeIn()

      date = moment(track.pubDate).format 'MMM Do YYYY'
      Materialize.toast "#{track.title} (#{date})", timeout, '', -> s.fadeOut 1000, -> s.stop()

    else if ($a.hasClass 'join')
      # console.log JSON.stringify data
      $a.addClass 'disabled'

      if data.id in (Session.get 'tracking')
        Materialize.toast 'Already subscribed to podcast', 1000
        return

      Meteor.call 'podcastAdd', data, (error, response) ->
        return if error?
        Session.set 'tracking', (_.pluck Meteor.user().profile.podcasts, '_id')
        Materialize.toast 'Subscribed to podcast', 1000

    else
      unless data.id in (Session.get 'tracking')
        Materialize.toast 'Podcast not found in tracking list', 1000
        return

      Meteor.call 'podcastRemove', data.id, (error, response) ->
        return if error?
        $p = $a.parent()
        Session.set 'tracking', (_.pluck Meteor.user().profile.podcasts, '_id')

        setTimeout ->
          $p.find('a.join.disabled').removeClass 'disabled'
          Materialize.toast 'Unsubscribed from podcast', 1000
        , 100


  'click .activator': (event) ->
    $card = $(event.target).parents '.card'
    $spinner = $card.find('.preloader-wrapper').addClass 'active'

    event.preventDefault()

    Meteor.call 'getFeed', ($card.data 'feed'), (error, response) ->
      unless error?
        # console.log (JSON.stringify response)
        $p = $('p.description', $card).text response.description

        $card.data meta: (_.omit response, ['info', 'link', 'owner'])
        $('span.tools > a', $card).removeClass 'disabled'

        $spinner.fadeOut ->
          $p.fadeIn()
          $(@).remove()

      else
        console.error error
        $spinner.remove()


  'click .card-image': (event) ->
    $(event.target).parents('.card').find('.activator').click()


  'click .card-reveal': (event) ->
    $(event.target).find('.card-title').click()


  'submit form': (event, template) ->
    event.preventDefault()
    Session.set 'results', []

    query =
      # attribute: 'descriptionTerm'
      entity: 'podcast'
      limit: 48
      term: (template.find '#query').value

    Meteor.call 'podcastSearch', query, (error, response) ->
      if error?
        console.error 'ERROR', error
        (Session.set 'results', {error})

      else
        # console.log (JSON.stringify response.results)
        (Session.set 'results', response.results)
