Template.search.helpers
  imbg: ->
    colors = [
      'red','pink','purple','deep-purple','indigo','blue','light-blue','cyan',
      'teal','green','light-green','lime','yellow','amber','orange','deep-orange',
      'brown','grey','blue-grey'
    ]

    shades = [
      'lighten-5','lighten-4','lighten-3','lighten-2','lighten-1',
      'darken-1','darken-2','darken-3','darken-4', ''
    ]

    class: [
      'card-image waves-block waves-effect waves-light'
      colors[_.random 0, (_.size colors) - 1]
      shades[_.random 0, (_.size shades) - 1]
    ].join ' '

  isExplicit: (value) ->
    value is 'explicit'

  isTracking: (id) ->
    id in (Session.get 'tracking')

  results: ->
    Session.get 'results'
