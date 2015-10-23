# TODO Add allow/deny rules
@Details = new Mongo.Collection('details')
@Search = new Mongo.Collection('search')


Session.setDefault 'colors', ['rgb(134, 50, 51)', 'rgb(234, 234, 234)', 'rgb(13, 24, 16)']
Session.setDefault 'podcast', {}
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
  colors = []
  (colors.push chroma color) for color in (Session.get 'colors')
  # console.log colors
  return colors


window.refreshColors = ->
  [baseColor, toolColor, backgroundColor] = window.getThemeColors()

  paint = (index, backgroundColor) ->
    $(".color-#{index + 1}")
      .css {backgroundColor}
      .colorize backgroundColor

  (paint i, color) for color, i in [backgroundColor, toolColor, baseColor]
  document.body.style.backgroundColor = baseColor


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
  window.setTheme (new ColorThief().getPalette img, 2, 9)
  window.refreshColors()


window.setTheme = (colors) ->
  return unless colors?
  Session.set 'colors', colors
  Session.set 'theme', (window.getThemeClass chroma colors[0])


window.toTheTop = (complete={}) ->
  $('html').velocity 'scroll',
    _.extend {complete},
    duration: $(window).scrollTop() / 3
    easing: 'ease-out'
    mobileHA: no


$.Velocity
  .RegisterEffect 'transition.justFadeIn', defaultDuration: 800, calls: [[opacity: 1]]
  .RegisterEffect 'transition.justFadeOut', defaultDuration: 800, calls: [[opacity: 0]]
  .defaults = (_.extend $.Velocity.defaults, duration: 500)

###
Meteor.startup ->
  lang = (TAPi18n.setLanguage window.navigator.userLanguage or window.navigator.language or 'en')

  Session.set 'loading', yes
  lang.done -> Session.set 'loading', no
  lang.fail (error) -> console.log error
###
