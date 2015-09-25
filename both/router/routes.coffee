Router.route '/',
  name: 'home'

  onBeforeAction: ->
    $('span.term', '#send').css fontStyle: 'normal'
    @next()

  template: 'home'


Router.route '/details/:url',
  data: -> (Details.findOne @params.url)
  name: 'details'
  template: 'details'
  waitOn: -> (Meteor.subscribe 'details', @params.url)


Router.route '/exit',
  template: 'loading'

  onBeforeAction: ->
    Meteor.logout()
    @next()

  onAfterAction: ->
    Router.go 'home'


Router.route '/search/:term',
  name: 'search'
  notFoundTemplate: 'noResults'
  template: 'search'

  onAfterAction: ->
    $('body,html').scrollTop 0

    Meteor.setTimeout ->
      $('li.new', 'ul.collection').process()

  onBeforeAction: ->
    $('span.term', '#send').css fontStyle: 'italic'
    @next()

  waitOn: ->
    try
      (Meteor.subscribe 'search', @params.term)

    catch error
      console.error error


# Router.route '/settings', -> @render 'Settings'
# Router.route '/tracking', -> @render 'TrackingList'
# Router.route '/tracking/:id', -> @render 'PodcastDetails', data: -> (Tracking.findOne id: @params.id)
