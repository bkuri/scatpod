EpisodeSchema = new SimpleSchema
  title:
    type: String

  subtitle:
    optional: true
    type: String

  summary:
    optional: true
    type: String

  published:
    optional: true
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
    max: 140
    optional: true
    type: String

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


PlaylistSchema = new SimpleSchema
  name:
    type: String

  tracks:
    type: [EpisodeSchema]


PodcastSchema = new SimpleSchema
  _id:
    type: Number

  name:
    type: String

  summary:
    max: 4000
    optional: true
    type: String

  categories:
    defaultValue: []
    optional: true
    type: [String]

  keywords:
    defaultValue: []
    optional: true
    type: [String]

  language:
    defaultValue: 'en'
    optional: true
    type: String

  episodes:
    optional: true
    type: [EpisodeSchema]

  explicit:
    defaultValue: false
    type: Boolean

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


TimeStampFields =
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


UserSchema = new SimpleSchema
  emails:
    optional: true
    type: [Object]

  'emails.$.address':
    regEx: SimpleSchema.RegEx.Email
    type: String

  'emails.$.verified':
    type: Boolean

  'profile.$.playlists':
    optional: true
    type: [new SimpleSchema [PlaylistSchema, TimeStampFields]]

  'profile.$.podcasts':
    optional: true
    type: [new SimpleSchema [PodcastSchema, TimeStampFields]]


Networks = new Mongo.Collection 'networks'


# Meteor.users.attachSchema UserSchema
Networks.attachSchema NetworkSchema
