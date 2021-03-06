Template.details.helpers
  accordionElements: ->
    icon = class: 'mdi-action-settings-ethernet mdi-rotate-90 right'
    [
      _.extend {icon}, {
        body: 'Show description'
        title: 'Summary'
      }
      _.extend {icon}, {
        body: 'Show description'
        title: 'Other details'
      }
    ]

  cid: ->
    (Session.get 'podcast').cid

  genres: ->
    window.getKeywords (Session.get 'podcast').cat

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


Template.episodeList.helpers
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
