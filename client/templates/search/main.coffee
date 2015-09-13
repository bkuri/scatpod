Template.search.created = ->
  @limit = new ReactiveVar 24


Template.search.rendered = ->
  @autorun _.bind ->
    Deps.afterFlush ->
      Session.set 'tracking', (_.pluck Meteor.user()?.profile.podcasts, '_id')

      # remove invalid images
      $('img', '.masonry-container')
        .on('error', -> $(@).remove())
        .filter(-> $(@).is 'img:not([src])')
        .remove()

      $('#query').focus()
  , this
