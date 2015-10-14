Template.results.created = ->
  @count = new ReactiveVar 0
  @limit = new ReactiveVar 40


Template.results.rendered = ->
  $fab = $('#fab')
  $results = $('.row').first()
  $win = $(window)
  tid = null
  tmp = Template.instance()

  @autorun _.bind ->
    Deps.afterFlush ->
      # $('body').bokeh()

      Session.set 'tracking', (_.pluck Meteor.user()?.profile.podcasts, '_id')

      # remove invalid images
      $('img', '.masonry-container')
        .on 'error', -> $(@).remove()
        .filter -> $(@).is 'img:not([src])'
        .remove()

      $win.scroll _.throttle ->
        bottom = if ($win.scrollTop() > 300) then '44px' else '-55px'

        if ($fab.css 'bottom') isnt bottom
          $fab
            .not '.velocity-animating'
            .velocity {bottom}, 150, [500, 20]

        return unless tmp.limit.get() < tmp.count.get()
        bottom = ($results.offset().top + $results.height())
        threshold = $win.scrollTop() + $win.height()
        return unless (bottom <= threshold)

        tmp.limit.set (tmp.limit.get() + 40)

        clearTimeout tid?
        tid = Meteor.setTimeout -> $('.new', 'ul.collection').process()

      , 300, leading: no

  , this
