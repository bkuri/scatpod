Template.search.helpers
  imbg: ->
    class: [
      'card-image waves-block waves-effect waves-light'

      _.sample [
        'red','pink','purple','deep-purple','indigo','blue','cyan',
        'teal','green','lime','yellow','amber','orange','deep-orange'
      ]

      _.sample ['', 'darken-1', 'darken-2', 'darken-3', 'darken-4', 'lighten-1', 'lighten-2']
    ].join ' '


  isExplicit: (value) ->
    value is 'explicit'


  isTracking: (id) ->
    id in (Session.get 'tracking')


  labelize: (genres) ->
    labels = _.reject (_.first genres, 3), (g) -> (g.toLowerCase() is 'podcasts')
    # labels.sort (a, b) -> (a.length - b.length)
    labels


  moreResults: ->
    Template.instance().limit.get() < (Session.get 'results').length


  results: ->
    results = (Search.find {}, reactive: no).fetch()[0]
    template = Template.instance()
    values = _.values (_.omit results, '_id')

    $('#brand').text "\"#{results._id}\""
    template.count.set values.length
    _.take values, template.limit.get()


  smallScreen: ->
    window.innerWidth < 601


  truncate: (what, limit) ->
    # console.log "#{what} (#{what.length})"
    return what if (limit > what.length)
    "#{(what.substr 0, limit).trim()}…"
