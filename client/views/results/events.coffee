Template.results.events
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
    date = (moment item.pubDate).format 'MMM Do, YYYY'
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


  'click a.attach': (event, template) ->
    $a = $(event.currentTarget)
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


  'click a.detach': (event, template) ->
    $a = $(event.currentTarget)
    id = ($a.parents '.card').data 'id'

    unless id in (Session.get 'tracking')
      Materialize.toast 'Podcast not found in tracking list', 1000
      return

    Meteor.call 'podcastRemove', id, (error, response) ->
      return if error?
      # $desc = $a.parent()
      Session.set 'tracking', (_.pluck Meteor.user().profile.podcasts, '_id')

      Meteor.setTimeout ->
        # $('a.join.disabled', $p).removeClass 'disabled'
        Materialize.toast 'Unsubscribed from podcast', 1000
      , 100


  'click ul.collection a.primary-content': (event, template) ->
    $col = $('li', 'ul.collection')
    data = $(event.currentTarget).parent().data()
    img = (event.currentTarget.querySelector 'img.thumb')
    url = (encodeURIComponent data.url)

    event.preventDefault()
    window.setTheme (new ColorThief().getPalette img, 3, 1)

    $col.onlyVisible().velocity
      o:
        complete: -> (Router.go 'details', {url})
        duration: 1000
        stagger: 150

      p: 'transition.fadeOut'

    ($col.onlyVisible yes).css opacity: 0
    Session.set 'podcast', (_.omit data, 'url', 'velocity')


  'click .activator': (event) ->
    event.preventDefault()
    $card = $(event.currentTarget).parents '.card'
    $spinner = $('.preloader-wrapper', $card).addClass 'active'

    Meteor.call 'getFeed', ($card.data 'feed'), (error, data) ->
      unless error?
        $p = $('p.description', $card)
        desc = if (_.isArray data.description) then data.description[0] else data.description
        limit = 280

        if (desc.length > limit) then desc = "#{(desc.substr 0, limit).trim()}…"
        $card.data meta: (_.omit data, ['description', 'info', 'link', 'owner'])
        $('span.tools > a', $card).not('.playing').removeClass 'disabled'

        $spinner.velocity
          opacity: 0

          complete: ->
            $p.text(desc).velocity opacity: 1, duration: 0.5
            # $spinner.parents('.valign-wrapper').remove()

      else
        console.error error
        $spinner.velocity opacity: 0, duration: 0.5


  'click .card-image': (event) ->
    $(event.currentTarget).parents('.card').find('.activator').click()

  ###
  'click .card-reveal': (event) ->
    $('body > div.material-tooltip').remove()
    $(event.currentTarget).find('.card-title').click()
  ###

  'mouseenter .hoverable': (event, template) ->
    $(event.currentTarget).find('.card-image > img').addClass 'hovering'


  'mouseleave .hoverable': (event, template) ->
    $(event.currentTarget).find('.card-image > img').removeClass 'hovering'
