configureService = (service, client, secret) ->
  ServiceConfiguration.configurations.upsert {service}, $set: _.extend client, {secret}

Meteor.startup ->
  configureService 'facebook', appId: 'XXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
  configureService 'google', clientId: 'XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com', 'XXXXXXXXXXXXXXXXX-XXXXXX'
  configureService 'twitter', consumerKey: 'XXXXXXXXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
