Template.episodes.helpers
  isEpisodeQueued: (url) ->
    url in Template.instance().queued()


  list: ->
    (Session.get 'podcast').list


  name: ->
    (Session.get 'podcast').name


  tracking: ->
    (Session.get 'podcast').cid in (Session.get 'tracking')


Template.episodeItem.helpers
  released: (date) ->
    (moment date).format 'MMMM Do, YYYY'


  truncate: (what, limit) ->
    return what if (limit > what.length)
    "#{(what.substr 0, limit).trim()}…"
