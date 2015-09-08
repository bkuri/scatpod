Template.search.rendered = ->
  @autorun _.bind ->
    tracking = (_.pluck Meteor.user()?.profile.podcasts, '_id')

    Deps.afterFlush ->
      Session.set 'tracking', tracking
      $('.tooltipped').tooltip delay: 50

      # remove invalid images
      $('img', '.masonry-container')
        .on('error', -> $(@).remove())
        .filter(-> $(@).is 'img:not([src])')
        .remove()
  , this
