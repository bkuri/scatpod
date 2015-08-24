URL = 'https://gpodder.net'

apiCall = (url, params, callback) ->
  #console.log url, (JSON.stringify params)

  try
    response = (HTTP.get url, {params}).data
    callback null, response

  catch error
    console.log error.stack
    code = 500
    mesg = 'Cannot access API'

    callback (new Meteor.Error code, mesg), null


Meteor.methods
  'searchPodcasts': (q) ->
    @unblock()
    (Meteor.wrapAsync apiCall) "#{URL}/search.json", {q}
