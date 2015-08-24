#https://api.import.io/store/data/61c405bd-17f4-4500-99df-229904d53ce0/_query?input/search=news&_user=2b897b24-4d36-4395-b037-e96acf37cef3&_apikey=2b897b244d364395b037e96acf37cef37248d0f78858779e9ec151dc726487c7e939d1638e97ff94b645cfb89ef0e8220e9831ad255f5d2015e93e4a89017cddb1d8637d24699b212aa9da3a2b4cc5a3
# Discover = new Mongo.Collection 'Discover'
# Settings = new Mongo.Collection 'Settings'
# Tracking = new Mongo.Collection 'Tracking'

Router.route '/', -> @render 'home'
Router.route '/search', -> @render 'search'
Router.route '/settings', -> @render 'Settings'
Router.route '/tracking', -> @render 'TrackingList'
Router.route '/tracking/:id', -> @render 'PodcastDetails', data: -> (Tracking.findOne id: @params.id)

if Meteor.isClient
  # counter starts at 0
  Session.setDefault 'counter', 0

  Template.home.helpers
    counter: ->
      Session.get 'counter'

  Template.home.events
    'click button': (event, template) ->
      # increment the counter when button is clicked
      Session.set 'counter', (Session.get 'counter') + 1

  Template.search.helpers
    results: -> Session.get 'results'

  Template.search.events
    'click button': (event, template) ->
      Meteor.call 'searchPodcasts', (template.find '#searchQuery').value, (error, response) ->
        unless error?
          Session.set 'results', response
          return response
        else (Session.set 'results', {error})


if Meteor.isServer
  Meteor.startup ->
    # do server stuff
