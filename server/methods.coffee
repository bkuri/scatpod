apiCall = (url, params, callback) ->
  # console.log url, (JSON.stringify params)

  try
    callback null, (HTTP.get url, {params}).data

  catch error
    callback (new Meteor.Error 500, 'API error'), null


getFeed = (url, callback) ->
  meteorError = (new Meteor.Error 500, 'Could not fetch feed')

  try
    HTTP.get url, (error, data) ->
      unless error?
        xml = xml2js.parseStringSync data.content,
          explicitArray: false
          tagNameProcessors: [xml2js.processors.stripPrefix]

        callback null, xml.rss.channel

      else (callback meteorError, null)

  catch error
    callback meteorError, null


Meteor.methods
  'getFeed': (url) ->
    @unblock()
    (Meteor.wrapAsync getFeed) url

  'podcastSearch': (params) ->
    @unblock()
    (Meteor.wrapAsync apiCall) "https://itunes.apple.com/search", params
