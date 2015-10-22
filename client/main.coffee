@Details = new Mongo.Collection('details')
@Search = new Mongo.Collection('search')


Session.setDefault 'colors', [[134, 50, 51], [234, 234, 234], [13, 24, 16]]
Session.setDefault 'podcast', {}
Session.setDefault 'scrollTop', 0
Session.setDefault 'theme', 'negative'
Session.setDefault 'tracking', []


Blaze.addBodyClass [
  -> (Session.get 'theme')
  -> Meteor.status().status
]


window.getKeywords = (keywords) ->
  return [] unless keywords?
  keys = if (_.isString keywords) then keywords else keywords[0]

  keys
    .split if (', ' in keys) then ', ' else ','
    .filter (genre) -> genre.toLowerCase() isnt 'podcasts'


window.getThemeClass = (c) ->
  contrast = (color1, color2) -> (chroma.contrast color1, color2)
  if (contrast c, 'fff') > (contrast c, '000') then 'negative' else 'positive'


window.getThemeColors = ->
  [
    (chroma Session.get('colors')[2])
    (chroma Session.get('colors')[0])
    (chroma Session.get('colors')[1])
  ]


window.refreshColors = ->
  [backgroundColor, baseColor, toolColor] = window.getThemeColors()
  # contrast = (chroma.contrast toolColor, backgroundColor)

  document.body.style.backgroundColor = baseColor
  $('a', '#fab').colorize toolColor

  $('.color-1, .divider')
    .css {backgroundColor}
    .colorize backgroundColor

  $('.color-2')
    .css backgroundColor: toolColor
    .colorize toolColor


window.refreshListItems = ->
  $li = $('li.collection-item', 'ul.collection')

  $li
    .onlyVisible()
    .velocity 'transition.slideRightIn',
      duration: 800
      stagger: 200
      complete: -> $li.css(opacity: 1)


window.refreshTheme = (index=3) ->
  img = $('li', 'ul.collection').onlyVisible().find('img')[index]
  return unless img?
  window.setTheme new ColorThief().getPalette(img), 2, 10
  window.refreshColors()


window.setTheme = (colors) ->
  Session.set 'colors', colors
  Session.set 'theme', (window.getThemeClass chroma colors[0])


window.toTheTop = (duration, callback={}) ->
  $('html').velocity 'scroll',
    _.extend callback,
    duration: duration or ($(window).scrollTop() / 3)
    easing: 'ease-out'
    mobileHA: no


$.Velocity.defaults = (_.extend $.Velocity.defaults, duration: 500)

$.Velocity
  .RegisterEffect 'transition.justFadeIn', defaultDuration: 800, calls: [[opacity: 1]]
  .RegisterEffect 'transition.justFadeOut', defaultDuration: 800, calls: [[opacity: 0]]

###
Meteor.startup ->
  lang = (TAPi18n.setLanguage window.navigator.userLanguage or window.navigator.language or 'en')

  Session.set 'loading', yes
  lang.done -> Session.set 'loading', no
  lang.fail (error) -> console.log error
###
