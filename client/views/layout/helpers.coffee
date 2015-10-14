Template.navbar.helpers
  recognized: -> Meteor.userId()?
  searching: -> $('#search').hasClass 'hide'
  term: -> Router.current().params.term or 'scatpod'
