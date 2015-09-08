Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'not_found'


Router.plugin 'ensureSignedIn', only: ['search']


AccountsTemplates.configure
  showForgotPasswordLink: true
  overrideLoginErrors: true
  enablePasswordChange: true
  sendVerificationEmail: false
  confirmPassword: true
  negativeValidation: true
  positiveValidation:true
  negativeFeedback: false
  positiveFeedback:false


AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'enrollAccount'
AccountsTemplates.configureRoute 'forgotPwd'
AccountsTemplates.configureRoute 'resetPwd'
AccountsTemplates.configureRoute 'signIn'
AccountsTemplates.configureRoute 'signUp'
AccountsTemplates.configureRoute 'verifyEmail'


T9n.setLanguage 'en'
