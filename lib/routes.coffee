Router.route '/', -> @render 'home'
Router.route '/search', -> @render 'search'
Router.route '/settings', -> @render 'Settings'
Router.route '/tracking', -> @render 'TrackingList'
Router.route '/tracking/:id', -> @render 'PodcastDetails', data: -> (Tracking.findOne id: @params.id)
