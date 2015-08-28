Template.search.events
  'click .card-reveal': (event, template) ->
    $(event.target).find('.card-title').first().click()

  'submit form': (event, template) ->
    event.preventDefault()
    Session.set 'results', []

    Meteor.call 'searchPodcasts', (template.find '#query').value, (error, response) ->
      unless error?
        Session.set 'results', response
        return response
      else (Session.set 'results', {error})


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
      'activator card-image waves-block waves-effect waves-light'
      colors[_.random 0, (_.size colors) - 1]
      shades[_.random 0, (_.size shades) - 1]
    ].join ' '

  results: -> Session.get 'results'


Template.search.rendered = ->
  # remove invalid images
  $('img', '.masonry-container')
    .on('error', -> $(@).remove())
    .filter(-> $(@).is 'img:not([src])')
    .remove()
