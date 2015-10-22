Template.layout.events
  'blur #search input': (event, template) ->
    return unless template.searching.get()

    $('span.term', '#send').removeClass 'hide'
    $('#search').addClass 'hide'


  'click #fab > a': (event) ->
    event.preventDefault()
    window.toTheTop()


  'click #send a': (event, template) ->
    event.preventDefault()
    $search = $('#search')

    if ($search.hasClass 'hide')
      $(event.currentTarget).find('span.term').addClass 'hide'

      $search
        .removeClass 'hide'
        .find 'input'
        .val Router.current().params.term
        .focus()

      template.searching.set yes

    else $search.find('input').focus()


  'focus #search input': (event) ->
    event.currentTarget.select()


  'mousedown #send a': (event, template) ->
    event.preventDefault()
    $('input', '#search').focus() if template.searching.get()


  'submit form': (event, template) ->
    event.preventDefault()
    term = $('input', '#search').blur().val().trim()
    return unless term.length

    # template.query.set term
    template.searching.set no

    if (ActiveRoute.name is 'search')
      $('li', 'ul.collection').process yes, -> (Router.go 'search', {term})
    else (Router.go 'search', {term})
