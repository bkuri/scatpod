Router.route 'home',
  path: '/'

  onBeforeAction: ->
    $('.button-collapse', 'nav').sideNav 'hide'
    $('span.term', '#send').css fontStyle: 'normal'

    window.refreshTheme(10)
    @next()

  onAfterAction: ->
    # document.body.scrollTop = (Session.get 'scrollTop')
    console.log (Session.get 'scrollTop')


Router.route 'details',
  data: -> (Details.findOne @params.url)
  path: '/details/:url',
  waitOn: -> (Meteor.subscribe 'details', @params.url)

  onBeforeAction: ->
    [backgroundColor, baseColor, toolColor] = window.getThemeColors()

    Meteor.setTimeout ->
      $('li', '#details ul.collection')
        .addClass (window.getThemeClass backgroundColor)
        .css {backgroundColor}

      $('.summary', '#details').css backgroundColor: toolColor
      $('a.queue, a.queued', '#details').css borderRightColor: toolColor
      $('.collapsible-header, .summary .col, .toolbar a', '#details').colorize toolColor
      window.refreshColors()

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
  template: 'results'

  onBeforeAction: ->
    $('span.term', '#send').css fontStyle: 'italic'

    Meteor.setTimeout ->
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
