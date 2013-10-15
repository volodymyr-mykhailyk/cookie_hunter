class window.Hunter
  constructor: (@hunting, @$li) ->
    @$link = @$li.find('a.hunter_link').first()
    @url = @$link.attr('href')
    @$link.attr('href', '#')
    @id = @$link.attr('data-id')
    @email = @$link.attr('data-email')
    @init()

  @init = (hunting, @$div) =>
    window.Hunter.hunters = {}
    $.each $('li.hunter'), (i, li) =>
      hunter = new Hunter(hunting, $(li))
      window.Hunter.hunters[hunter.id] = hunter
    window.Hunter.hunters

  init: ->
    @$link.on 'click', (e) =>
      e.preventDefault()
      @send_request()

  send_request: ->
    timestamp = (new Date).getMilliseconds()
    $.getJSON @url, {hunter_id: @id, timestamp: "#{timestamp}"}, (data) =>
      @hunting.success(data)

  update: (data) ->
    @update_count(data['cookies'])

  update_count: (count) ->
    @$link.html("#{@email} (#{count})")
