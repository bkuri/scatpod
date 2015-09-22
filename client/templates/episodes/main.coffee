Template.details.rendered = ->
  @autorun _.bind ->
    template = Template.instance()

    Deps.afterFlush ->
      ###
      canvas = (document.getElementById 'bg')
      # context = (canvas.getContext '2d')
      img = new Image()

      img.onload = ->
        # [h, w] = [canvas.height, canvas.width]
        # context.drawImage img, 0, 0, w, h
        # stackBlurCanvasRGBA 'bg', 0, 0, w, h, 100
        StackBlur.image img, canvas, 100

      img.src = $(canvas).data 'img'
      ###
  , this


getQueued = ->
  console.log 'getQueued()'
  {profile} = Meteor.user()
  (_.findWhere profile.playlists, name: profile.playlist).tracks


Template.episodes.created = ->
  @queued = -> (_.pluck getQueued(), 'url')

###
Template.episodes.rendered = ->
  @autorun _.bind ->
    template = Template.instance()

    Deps.afterFlush ->

  , this
###
