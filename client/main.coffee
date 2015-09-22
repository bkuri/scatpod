@Details = new Mongo.Collection 'details'
@Search = new Mongo.Collection 'search'


Session.setDefault 'podcast', {}
Session.setDefault 'tracking', []


Meteor.startup ->
  ###
  lang = (TAPi18n.setLanguage window.navigator.userLanguage or window.navigator.language or 'en')

  Session.set 'loading', yes
  lang.done -> Session.set 'loading', no
  lang.fail (error) -> console.log error
  ###
