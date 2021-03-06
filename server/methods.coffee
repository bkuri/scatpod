apiCall = (url, params, callback) ->
  # console.log url, (JSON.stringify params)

  try
    callback null, (HTTP.get url, {params}).data

  catch error
    callback (new Meteor.Error 500, 'API error'), null


getCopyright = (data) ->
  return '' unless data.copyright?
  cc = if (typeof data.copyright is 'string') then data.copyright else data.copyright[0]

  # console.log 'COPYRIGHT', JSON.stringify cc
  return cc

###
getEpisodes = (data) ->
  return [] unless data.item?

  episodes = []
  omit = ['author', 'category', 'description', 'duration', 'enclosure', 'explicit', 'guid', 'keywords', 'pubDate', 'summary']

  for ep in data.item
    episodes.push _.extend (_.omit ep, omit),
      explicit: (getExplicit ep)
      published: ep.pubDate
      # summary: (getSummary ep)
      url: (getLink ep)

  return episodes
###

getExplicit = (p) ->
  p.explicit? and (p.explicit.toLowerCase() is 'yes')


getFeed = (url, callback) ->
  HTTP.get url, (error, data) ->
    meteorError = (new Meteor.Error 500, 'Could not fetch feed')

    unless error?
      try
        xml = xml2js.parseStringSync data.content,
          explicitArray: no
          tagNameProcessors: [xml2js.processors.stripPrefix]

        # TODO: consider filtering usless stuff before sending it over the wire
        callback null, xml.rss.channel

      catch error
        callback meteorError, null

    else (callback meteorError, null)


getImage = (data) ->
  return '' unless data.image?
  img = data.image.url or data.image.$?.href or data.image[0]?.url or data.image[0].$?.href or ''

  # console.log 'IMAGE', img
  return img


getKeywords = (data) ->
  return [] unless data.keywords?
  keys = if (typeof data.keywords is 'string') then data.keywords else data.keywords[0]

  keys = switch
    when (keys.indexOf ', ') then (keys.split ', ')
    else (keys.split ',')

  # console.log 'KEYWORDS', JSON.stringify keys
  return keys


getLink = (data) ->
  return '' unless data.link? or data.enclosure?
  url = data.link or data.enclosure.$.url
  # console.log 'URL', url
  return url


getSummary = (p) ->
  return p.description if p.description?.length
  return p.summary if p.summary?.length
  return p.subtitle if p.subtitle?.length
  return ''


Meteor.methods
  emailSend: (data) ->
    check data, email: String, name: String

    from = 'robot@scatpod.xyz'
    html = (SSR.render 'welcome', data)
    subject = 'Welcome to scatpod'
    to = data.email

    @unblock()
    console.log html
    Email.send {to, from, subject, html}


  episodeAdd: (track, name='main') ->
    find = _id: Meteor.userId(), 'profile.playlists.name': name
    Meteor.users.update find, $push: 'profile.playlists.$.tracks': track


  episodeRemove: (track, name='main') ->
    find = _id: Meteor.userId(), 'profile.playlists.name': name
    Meteor.users.update find, $pull: 'profile.playlists.$.tracks': track


  getFeed: _.memoize (url) ->
    @unblock()
    (Meteor.wrapAsync getFeed) url

  ###
  fetchImage: (url) ->
    @unblock()
    (HTTP.get url, responseType: 'arraybuffer').content
  ###

  podcastAdd: (data) ->
    podcast =
      _id: data.cid
      categories: data.cat or []
      copyright: (getCopyright data.meta)
      # episodes: (getEpisodes data.meta)
      explicit: (getExplicit data.meta)
      keywords: (getKeywords data.meta)
      language: data.meta.language or undefined
      name: data.meta.title
      # summary: (getSummary data.meta)
      thumbnail: (getImage data.meta)
      url: (getLink data.meta)

    @unblock()
    Meteor.users.update {_id: Meteor.userId()}, $push: 'profile.podcasts': podcast


  podcastRemove: (_id) ->
    userid = _id: Meteor.userId()
    # TODO remove episodes with parent === _id
    # Meteor.users.update userid, $pull: 'profile.playlists': 'tracks.parent': $eq: _id, {multi: yes}
    Meteor.users.update userid, $pull: 'profile.podcasts': {_id}


  podcastSearch: _.memoize (term) ->
    params = _.extend {term},
      entity: 'podcast'
      limit: 200

    @unblock()
    (Meteor.wrapAsync apiCall) 'https://itunes.apple.com/search', params
