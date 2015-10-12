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

  onAfterAction: _.throttle ->
    $li = $('li', 'ul.collection')

    $li.onlyVisible().velocity 'transition.slideRightIn',
      complete: -> ($li.css opacity: 1)
      duration: 1000
      stagger: 150

  , 2000, leading: no

  onBeforeAction: ->
    Meteor.setTimeout ->
      $('#details').velocity 'transition.fadeIn', duration: 1000

    @next()


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

  onBeforeAction: ->
    $('span.term', '#send').css fontStyle: 'italic'

    Meteor.setTimeout ->
      $('body').css backgroundColor: '#222'
      $('li.new', 'ul.collection').process()

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
