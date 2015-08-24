# counter starts at 0
Session.setDefault 'counter', 0

Template.counter.helpers
  counter: ->
    Session.get 'counter'

Template.counter.events
  'click button': (event, template) ->
    # increment the counter when button is clicked
    Session.set 'counter', (Session.get 'counter') + 1
