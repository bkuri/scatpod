Playlist = (Mongo.Collection.get 'playlist')
Tracking = (Mongo.Collection.get 'tracking')

Meteor.publish 'playlist', ->
  Playlist.find()

Meteor.publish 'tracking', ->
  Tracking.find()
