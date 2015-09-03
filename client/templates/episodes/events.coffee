Template.episodes.events
  'click a.queue': (event) ->
    event.preventDefault()
    console.log JSON.stringify $(event.target).parent().data()
