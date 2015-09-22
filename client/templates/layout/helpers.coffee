Template.navbar.helpers
  name: ->
    'scatpod'


  term: ->
    Router.current().params.term or 'scatpod'


  searching: ->
    $('#search').hasClass 'hide'
