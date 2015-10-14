@Details = new Mongo.Collection('details')
@Search = new Mongo.Collection('search')


Session.setDefault 'colors', ['#222', '#fff', '#000', '#fab']
Session.setDefault 'podcast', {}
Session.setDefault 'theme', 'negative'
Session.setDefault 'tracking', []


Blaze.addBodyClass [
  -> (Session.get 'theme')
  -> Meteor.status().status
]


# get average color from an image
# see http://stackoverflow.com/a/2541680/4305736
window.averageColor = (img) ->
  buffer = (document.createElement 'canvas')
  context = (buffer.getContext '2d')

  buffer.height = img.naturalHeight or img.offsetHeight or img.height
  buffer.width = img.naturalWidth or img.offsetWidth or img.width

  try
    context.drawImage img, 0, 0
    data = (context.getImageData 0, 0, buffer.width, buffer.height)

  catch error
    console.error error
    return null

  blockSize = 5
  count = 0
  i = -4
  [r, g, b] = [0, 0, 0]

  while (i += blockSize * 4) < data.data.length
    ++count
    r += data.data[i]
    g += data.data[i + 1]
    b += data.data[i + 2]

  return [
    r // count
    g // count
    b // count
  ]


window.getKeywords = (keywords) ->
  return [] unless keywords?
  keys = if (_.isString keywords) then keywords else keywords[0]

  keys
    .split if (', ' in keys) then ', ' else ','
    .filter (genre) -> genre.toLowerCase() isnt 'podcasts'


window.setTheme = (palette) ->
  colors = []

  palette
    .sort (a, b) -> chroma(a).luminance() > chroma(b).luminance()
    .map (color) -> colors.push chroma(color).css()

  base = (chroma colors[1])
  luminance = base.luminance()
  setClass = (l) -> if (l < 0.5) then 'negative' else 'positive'

  # console.log "color: #{base.hex()}\tluminance: #{luminance}"
  document.body.style.backgroundColor = colors[1]

  $('#mobile-nav, .secondary-color, .divider')
    .css backgroundColor: colors[3]
    .removeClass 'negative positive'
    .addClass (setClass chroma(colors[3]).luminance())

  Session.set 'colors', colors
  Session.set 'theme', (setClass luminance)


$.Velocity.defaults = (_.extend $.Velocity.defaults, duration: 500)

###
Meteor.startup ->
  lang = (TAPi18n.setLanguage window.navigator.userLanguage or window.navigator.language or 'en')

  Session.set 'loading', yes
  lang.done -> Session.set 'loading', no
  lang.fail (error) -> console.log error
###
