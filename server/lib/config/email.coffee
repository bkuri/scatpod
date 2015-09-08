Accounts.emailTemplates.siteName = 'MySite'

Accounts.emailTemplates.from = 'MySite <support@mysite.com>'

Accounts.emailTemplates.resetPassword.subject = (user) ->
  "Message for #{user.profile.displayName}"

Accounts.emailTemplates.resetPassword.text = (user, url) ->
  "Dear #{user.profile.displayName},\n\nClick the following link to set your new password:\n#{url}\n\nCheers, MySite"
