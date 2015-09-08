Meteor.startup ->
  # Add Facebook configuration entry
  ServiceConfiguration.configurations.update(
    {service: 'facebook'}
    {
      $set:
        appId: 'XXXXXXXXXXXXXXX'
        secret: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    }
    {upsert: true}
  )

  # Add Google configuration entry
  ServiceConfiguration.configurations.update(
    {service: 'google'}
    {
      $set:
        clientId: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        client_email: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        secret: 'XXXXXXXXXXXXXXXXXXXXXXXX'
    }
    {upsert: true}
  )
