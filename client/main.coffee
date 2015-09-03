Meteor.subscribe 'playlist'
Meteor.subscribe 'tracking'

Meteor.startup ->
  ###
  lang = (TAPi18n.setLanguage window.navigator.userLanguage or window.navigator.language or 'en')

  Session.set 'loading', true
  lang.done -> Session.set 'loading', false
  lang.fail (error) -> console.log error
  ###

  Session.setDefault 'podcast', {}
