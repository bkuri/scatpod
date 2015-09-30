EpisodeSchema = new SimpleSchema
  title:
    type: String

  subtitle:
    optional: yes
    type: String

  summary:
    optional: yes
    type: String

  published:
    optional: yes
    type: Date

  duration:
    min: 0
    optional: yes
    type: Number

  offset:
    min: 0
    optional: yes
    type: Number

  parent:
    type: Number

  progress:
    decimal: yes
    defaultValue: 0
    label: 'Progess %'
    max: 100
    min: 0
    optional: yes
    type: Number

  'bookmarks.$.what':
    label: 'What'
    max: 140
    optional: yes
    type: String

  'bookmarks.$.when':
    label: 'When'
    min: 0
    type: Number

  explicit:
    defaultValue: no
    optional: yes
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
    optional: yes
    type: String

  categories:
    defaultValue: []
    optional: yes
    type: [String]

  keywords:
    defaultValue: []
    optional: yes
    type: [String]

  language:
    defaultValue: 'en'
    optional: yes
    type: String

  episodes:
    optional: yes
    type: [EpisodeSchema]

  explicit:
    defaultValue: no
    type: Boolean

  copyright:
    optional: yes
    type: String

  thumbnail:
    label: 'Thumbnail URL'
    optional: yes
    type: String

  url:
    label: 'Podcast URL'
    optional: yes
    type: String


NetworkSchema = new SimpleSchema
  name:
    type: String

  podcasts:
    type: [PodcastSchema]

  thumbnail:
    label: 'Thumbnail URL'
    optional: yes
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

    denyInsert: yes
    optional: yes
    type: Date


UserSchema = new SimpleSchema
  emails:
    optional: yes
    type: [Object]

  'emails.$.address':
    regEx: SimpleSchema.RegEx.Email
    type: String

  'emails.$.verified':
    type: Boolean

  'profile.playlist':
    defaultValue: 'main'
    optional: yes
    type: String

  'profile.settings':
    defaultValue: []
    optional: yes
    type: [Object]

  'profile.$.playlists':
    optional: yes
    type: [new SimpleSchema [PlaylistSchema, TimeStampFields]]

  'profile.$.podcasts':
    optional: yes
    type: [new SimpleSchema [PodcastSchema, TimeStampFields]]


@Networks = new Mongo.Collection 'networks'


# Meteor.users.attachSchema UserSchema
@Networks.attachSchema NetworkSchema
