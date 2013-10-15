class window.Hunting
  constructor: (@$div) ->
    @init_components()

  init_components: ->
    @hunters = new window.Hunter.init(@, $('#hunters_div'))
    @cookies = new window.Cookies(@, $('#cookies_div'))
    @steal_bucket = new window.StealBucket(@, $('#cookies_div'))

  update: ->
    $.getJSON '/hunting', (data) =>
      @success(data)

  success: (data) ->
    if data['stockpile']
      @cookies.update(data['stockpile'])
    if data['steal_bucket']
      @steal_bucket.update(data['steal_bucket'])
    if data['hunters']
      for hunter_data in data['hunters']
        hunter = @hunters[hunter_data['id']]
        hunter.update(hunter_data) if hunter

