Template.details.helpers
  accordionElements: ->
    [
      {
        body: 'Show description'
        icon: class: 'mdi-action-settings-ethernet mdi-rotate-90 right white-text'
        title: 'Summary'
      }
      {
        body: 'Show description'
        icon: class: 'mdi-action-settings-ethernet mdi-rotate-90 right white-text'
        title: 'Other details'
      }
    ]

  cid: ->
    (Session.get 'podcast').cid

  genres: ->
    genres = window.getKeywords (Session.get 'podcast').cat
    labels = _.reject (_.first genres, 3), (g) -> (g.toLowerCase() is 'podcast')
    # labels.sort (a, b) -> (a.length - b.length)
    labels

  height: ->
    document.documentElement.clientHeight

  img: ->
    (Session.get 'podcast').img

  isExplicit: (value) ->
    value is 'explicit'

  isTracking: (cid) ->
    cid in (Session.get 'tracking')

  width: ->
    document.documentElement.clientWidth


Template.episodes.helpers
  isEpisodeQueued: (url) ->
    url in Template.instance().queued()

  tracking: ->
    (Session.get 'podcast').cid in (Session.get 'tracking')


Template.episodeItem.helpers
  released: (date) ->
    (moment date).format 'MMMM Do, YYYY'

  truncate: (what, limit) ->
    return what if (limit > what.length)
    "#{(what.substr 0, limit).trim()}…"
