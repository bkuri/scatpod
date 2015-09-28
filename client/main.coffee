@Details = new Mongo.Collection 'details'
@Search = new Mongo.Collection 'search'


Session.setDefault 'podcast', {}
Session.setDefault 'tracking', []


window.getKeywords = (keywords) ->
  return [] unless keywords?
  keys = if (_.isString keywords) then keywords else keywords[0]
  keys.split if (', ' in keys) then ', ' else ','

window.name = 'scatpod'

###
Meteor.startup ->
  lang = (TAPi18n.setLanguage window.navigator.userLanguage or window.navigator.language or 'en')

  Session.set 'loading', yes
  lang.done -> Session.set 'loading', no
  lang.fail (error) -> console.log error
###
