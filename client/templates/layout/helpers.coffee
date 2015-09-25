Template.navbar.helpers
  searching: -> $('#search').hasClass 'hide'
  term: -> Router.current().params.term or window.name
