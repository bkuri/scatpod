# Podcast episode schema
EpisodeSchema = new SimpleSchema
  title:
    type: String

  subtitle:
    optional: true
    type: String

  summary:
    type: String

  published:
    type: Date

  duration:
    min: 0
    optional: true
    type: Number

  progress:
    decimal: true
    defaultValue: 0
    label: 'Progess %'
    max: 100
    min: 0
    optional: true
    type: Number

  'bookmarks.$.what':
    label: 'What'
    optional: true
    type: String
    max: 140

  'bookmarks.$.when':
    label: 'When'
    min: 0
    type: Number

  explicit:
    defaultValue: false
    optional: true
    type: Boolean

  url:
    label: 'Track URL'
    type: String


# Episode playlist schema
PlaylistSchema = new SimpleSchema
  tracks:
    type: [EpisodeSchema]


# Podcast schema
PodcastSchema = new SimpleSchema
  name:
    type: String

  summary:
    type: String
    max: 4000

  categories:
    optional: true
    type: [String]

  keywords:
    optional: true
    type: [String]

  language:
    defaultValue: 'en'
    optional: true
    type: String

  explicit:
    defaultValue: false
    type: Boolean

  episodes:
    type: [EpisodeSchema]

  copyright:
    optional: true
    type: String

  thumbnail:
    label: 'Thumbnail URL'
    optional: true
    type: String

  url:
    label: 'Podcast URL'
    optional: true
    type: String


# Podcast network schema
NetworkSchema = new SimpleSchema
  name:
    type: String

  podcasts:
    type: [PodcastSchema]

  thumbnail:
    label: 'Thumbnail URL'
    optional: true
    type: String

  url:
    label: 'Website'
    type: String


# Extra fields for tracking a podcast
TrackedFields =
  added:
    autoValue: ->
      if @isInsert then new Date
      else if @isUpsert then $setOnInsert: new Date
      else @unset()

    type: Date

  updated:
    autoValue: ->
      new Date if @isUpdate

    denyInsert: true
    optional: true
    type: Date


# Podcast schema + extra fields
TrackedPodcastSchema = new SimpleSchema [PodcastSchema, TrackedFields]


# Podcast subscription list
TrackingSchema = new SimpleSchema
  podcasts:
    type: [TrackedPodcastSchema]


# Define collections
Networks = new Mongo.Collection 'networks'
Playlist = new Mongo.Collection 'playlist'
Tracking = new Mongo.Collection 'tracking'


# Bind schemas to collections
Networks.attachSchema NetworkSchema
Playlist.attachSchema PlaylistSchema
Tracking.attachSchema TrackingSchema
