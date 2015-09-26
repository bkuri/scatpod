Router.route 'home',
  path: '/'

  onBeforeAction: ->
    $('.button-collapse', 'nav').sideNav 'hide'
    $('span.term', '#send').css fontStyle: 'normal'
    @next()


Router.route 'details',
  data: -> (Details.findOne @params.url)
  path: '/details/:url',
  waitOn: -> (Meteor.subscribe 'details', @params.url)


Router.route 'exit',
  path: '/exit'
  template: 'loading'

  onAfterAction: ->
    Router.go 'home'

  onBeforeAction: ->
    $('.button-collapse', 'nav').sideNav 'hide'
    Meteor.logout()
    @next()


Router.route 'search',
  notFoundTemplate: 'noResults'
  path: '/search/:term'

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


Router.route 'settings',
  path: '/settings'
  waitOn: -> (Meteor.subscribe 'userData')


# Router.route '/tracking', -> @render 'TrackingList'
# Router.route '/tracking/:id', -> @render 'PodcastDetails', data: -> (Tracking.findOne id: @params.id)
