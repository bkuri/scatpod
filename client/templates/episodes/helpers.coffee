Template.episodes.helpers
  list: ->
    (Session.get 'podcast').list

  name: ->
    (Session.get 'podcast').name

  tracking: ->
    (Session.get 'podcast').cid in (Session.get 'tracking')
