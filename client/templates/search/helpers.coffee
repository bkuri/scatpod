Template.search.helpers
  imbg: ->
    class: [
      'card-image waves-block waves-effect waves-light'

      _.sample [
        'red','pink','purple','deep-purple','indigo','blue','light-blue','cyan',
        'teal','green','light-green','lime','yellow','amber','orange','deep-orange',
        'brown','grey','blue-grey'
      ]

      _.sample [
        'lighten-5','lighten-4','lighten-3','lighten-2','lighten-1',
        'darken-1','darken-2','darken-3','darken-4', ''
      ]
    ].join ' '


  isExplicit: (value) ->
    value is 'explicit'


  isTracking: (id) ->
    id in (Session.get 'tracking')


  labelize: (genres) ->
    labels = _.reject genres, (g) -> (g.toLowerCase() is 'podcasts')
    labels.sort (a, b) -> (a.length - b.length)


  moreResults: ->
    Template.instance().limit.get() < (Session.get 'results').length


  results: ->
    _.take (Session.get 'results'), Template.instance().limit.get()


  truncate: (what, limit) ->
    # console.log "#{what} (#{what.length})"
    return what if (limit > what.length)
    "#{(what.substr 0, limit).trim()}…"
