Template.search.events
  'click span.tools > a': (event) ->
    $a = $(event.target).parent()

    event.preventDefault()
    event.stopPropagation()

    if ($a.hasClass 'list')
      Session.set 'podcast', $a.data()
      $('#episodes').openModal()

    else if ($a.hasClass 'play')
      item = ($a.data 'play')
      console.log 'play', JSON.stringify item
      s = new buzz.sound item.enclosure.$.url

      sound.stop() for sound in buzz.sounds

      if 'duration' in (Object.keys item)
        timer = (buzz.fromTimer item.duration)
        timeout = switch
          when timer > 0 then (timer * 1000) - (90 * 1000)
          else (90 * 1000)

        s.setTime(90).setVolume(0).fadeTo 80, 10000

      else
        timeout = (90 * 1000)
        s.fadeIn()

      date = moment(item.pubDate).format 'MMM Do YYYY'
      Materialize.toast "#{item.title} (#{date})", timeout, '', -> s.fadeOut 500, -> s.stop()

    else
      console.log 'join'


  'click .activator': (event) ->
    $card = $(event.target).parents '.card'
    $spinner = $card.find('.preloader-wrapper').addClass 'active'
    feed = ($card.data 'feed')

    event.preventDefault()

    Meteor.call 'getFeed', feed, (error, response) ->
      unless error?
        $p = $('p.description', $card).text response.description

        console.log response

        $('span.tools > a.list', $card).removeClass('disabled').data list: (_.head response.item, 10), name: response.title
        $('span.tools > a.play', $card).removeClass('disabled').data play: response.item[_.random response.item.length]
        # $('span.tools > a.join', $card).removeClass('disabled').data join: response

        $spinner.fadeOut ->
          $p.fadeIn()
          $(@).remove()

      else
        $spinner.remove()
        console.log error


  'click .card-image': (event) ->
    $(event.target).parents('.card').find('.activator').click()


  'click .card-reveal': (event) ->
    $(event.target).find('.card-title').click()


  'submit form': (event, template) ->
    event.preventDefault()
    Session.set 'results', []

    query =
      attribute: 'descriptionTerm'
      entity: 'podcast'
      term: (template.find '#query').value

    Meteor.call 'podcastSearch', query, (error, response) ->
      if error?
        console.error 'ERROR', error
        (Session.set 'results', {error})

      else
        console.log (JSON.stringify response.results)
        (Session.set 'results', response.results)
