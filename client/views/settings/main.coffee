Session.setDefault 'counter', 0
Session.setDefault 'slider', [20, 80]


Template.settings.rendered = ->
  @autorun _.bind ->
    Deps.afterFlush ->
      # tooltips = []

      $('#numResults')
        .noUiSlider
          connect: yes
          range: { min: 0, max: 100 }
          start: (Session.get 'slider')

        .on 'change', (event, value) ->
          Session.set 'slider', [
            Math.round value[0]
            Math.round value[1]
          ]

        .on 'slide', (event, value) ->
          Session.set 'slider', value
      ###
        .on 'update', (values, handle) ->
          tooltips[handle].innerHTML = values[handle]
          console.log tooltips[handle]

        .find '.noUi-handle'

        .each (i) ->
          $label = $('<div class="range-label"><span/></div>')
          tooltips[i] = ($label.find 'span')[0]
          $(@).append $label
      ###

  , this
