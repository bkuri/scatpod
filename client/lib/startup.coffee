Meteor.startup ->
  # attempt to set default language based on browser settings
  # @see http://justmeteor.com/blog/add-i18n-to-your-application/
  lang = window.navigator.userLanguage or window.navigator.language
  i18n.setDefaultLanguage if lang.match /es/ then 'es' else 'en'

  $('.button-collapse').sideNav();
  $('.parallax').parallax();
