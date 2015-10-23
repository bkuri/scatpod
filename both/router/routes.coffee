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

  onAfterAction: ->
    $details = $('#details')
    [baseColor, toolColor, backgroundColor] = window.getThemeColors()

    Meteor.setTimeout ->
      $('ul.collection > li', $details)
        .addClass (window.getThemeClass backgroundColor)
        .css {backgroundColor}

      # $('.summary', $details).css backgroundColor: toolColor
      $('a.queue, a.queued', $details).css borderRightColor: toolColor
      $('.collapsible-header, .summary .col, .toolbar a', $details).colorize toolColor
      window.refreshColors()


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
  template: 'results'

  onBeforeAction: ->
    $('span.term', '#send').css fontStyle: 'italic'

    Meteor.setTimeout ->
      $('li.new', 'ul.collection').process()
      window.refreshTheme()

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
