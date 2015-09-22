Template.details.helpers
  bg: (url) ->
    decodeURIComponent url


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
