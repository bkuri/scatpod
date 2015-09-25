configureService = (service, client, secret) ->
  ServiceConfiguration.configurations.upsert {service}, $set: _.extend client, {secret}

Meteor.startup ->
  configureService 'facebook', appId: '164439767230755', '7f973ea32dc93813aa552f5232c720cc'
  configureService 'google', clientId: '673306764826-e8dkoaauj6cq41t8bs0joob7b0cukjb5.apps.googleusercontent.com', 'YuSGBuLiTMayLJB6T-Vll0BP'
  configureService 'twitter', consumerKey: 'nW5ZRveY3kvLF6OqosnYyQ9yj', 'HUoRrlAksg6CHUKAKbFp5v7zSsZBNuev9OvBt06CgC7DrnG48G'
