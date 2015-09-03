Template.episodes.helpers
  getGUID: (g) ->
    keys = (Object.keys g).join ' '
    if '_' in keys then g._
    else if '$' in keys then g.$
    else g

  list: ->
    (Session.get 'podcast').list

  name: ->
    (Session.get 'podcast').name
