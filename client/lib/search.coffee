Template.search.helpers
  results: -> Session.get 'results'

Template.search.events
  'click button': (event, template) ->
    Meteor.call 'searchPodcasts', (template.find '#searchQuery').value, (error, response) ->
      unless error?
        Session.set 'results', response
        return response
      else (Session.set 'results', {error})
