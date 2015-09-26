Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'not_found'


Router.plugin 'ensureSignedIn',
  only: [
    'search'
    'settings'
  ]


AccountsTemplates.configure
  showForgotPasswordLink: yes
  overrideLoginErrors: yes
  enablePasswordChange: yes
  sendVerificationEmail: no
  confirmPassword: yes
  negativeValidation: yes
  positiveValidation: yes
  negativeFeedback: no
  positiveFeedback: no


AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'enrollAccount'
AccountsTemplates.configureRoute 'forgotPwd'
AccountsTemplates.configureRoute 'resetPwd'
AccountsTemplates.configureRoute 'signIn'
AccountsTemplates.configureRoute 'signUp'
AccountsTemplates.configureRoute 'verifyEmail'


T9n.setLanguage 'en'
