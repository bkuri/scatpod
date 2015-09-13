Template.search.events
  'click span.tools > a': (event) ->
    event.preventDefault()
    event.stopPropagation()


  'click span.tools > a.list': (event) ->
    data = ($(event.target).parents '.card').data()
    Session.set 'podcast', cid: data.id, list: (_.head data.meta.item, 10), name: data.meta.title
    $('#episodes').openModal()


  'click span.tools > a.play': (event) ->
    $a = $(event.target).parent()
    item = _.sample (($a.parents '.card').data 'meta').item
    date = (moment item.pubDate).format 'MMM Do YYYY'
    track = new buzz.sound item.enclosure.$.url

    $a.addClass 'disabled playing'
    sound.stop() for sound in buzz.sounds

    if 'duration' in (_.keys item)
      offset = (90 * 1000)
      timer = (buzz.fromTimer item.duration)
      timeout = unless (timer > 0) then offset else (timer * 1000) - offset
      (track.setTime 90).setVolume(0).fadeTo 80, 10000

    else
      timeout = (90 * 1000)
      track.fadeIn()

    Materialize.toast "#{track.title} (#{date})", timeout, '', ->
      track.fadeOut 1000, ->
        track.stop()
        $a.removeClass 'disabled playing'


  'click span.tools > a.join': (event, template) ->
    $a = $(event.target).parent()
    data = ($a.parents '.card').data()

    # console.log JSON.stringify data
    $a.addClass 'disabled'

    if data.id in (Session.get 'tracking')
      Materialize.toast 'Already subscribed to podcast', 1000
      return

    Meteor.call 'podcastAdd', data, (error, response) ->
      return if error?
      Session.set 'tracking', (_.pluck Meteor.user().profile.podcasts, '_id')
      Materialize.toast 'Subscribed to podcast', 1000


  'click span.tools > a.untrack': (event, template) ->
    $a = $(event.target).parent()
    id = ($a.parents '.card').data 'id'

    unless id in (Session.get 'tracking')
      Materialize.toast 'Podcast not found in tracking list', 1000
      return

    Meteor.call 'podcastRemove', id, (error, response) ->
      return if error?
      $desc = $a.parent()
      Session.set 'tracking', (_.pluck Meteor.user().profile.podcasts, '_id')

      Meteor.setTimeout ->
        $p.find('a.join.disabled').removeClass 'disabled'
        Materialize.toast 'Unsubscribed from podcast', 1000
      , 100


  'click .activator': (event) ->
    $card = $(event.target).parents '.card'
    $spinner = $card.find('.preloader-wrapper').addClass 'active'

    event.preventDefault()

    Meteor.call 'getFeed', ($card.data 'feed'), (error, data) ->
      unless error?
        # console.log (JSON.stringify data)
        limit = 280
        desc = if (limit > data.description.length) then data.description else "#{(data.description.substr 0, limit).trim()}…"
        $p = $('p.description', $card).text desc

        $card.data meta: (_.omit data, ['info', 'link', 'owner'])
        $('span.tools > a', $card).tooltip delay: 50
        $('span.tools > a:not(.playing)', $card).removeClass 'disabled'

        $spinner.fadeOut ->
          $p.fadeIn()
          $(@).parents('.valign-wrapper').remove()

      else
        console.error error
        $spinner.remove()


  'click .card-image': (event) ->
    $(event.target).parents('.card').find('.activator').click()


  'click .card-reveal': (event) ->
    $('body > div.material-tooltip').remove()
    $(event.target).find('.card-title').click()


  'click .load-more': (event, template) ->
    event.preventDefault()
    template.limit.set template.limit.get() + 24


  'submit form': (event, template) ->
    event.preventDefault()
    Session.set 'results', []

    query =
      # attribute: 'descriptionTerm'
      entity: 'podcast'
      limit: 200
      term: (template.find '#query').value

    Meteor.call 'podcastSearch', query, (error, response) ->
      if error?
        console.error 'ERROR', error
        (Session.set 'results', {error})

      else
        console.log (JSON.stringify response.results)
        (Session.set 'results', response.results)
