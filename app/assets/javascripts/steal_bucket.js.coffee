class window.StealBucket
  constructor: (@hunting, @$div) ->
    @$link = $('#get_steal_bucket_link')
    @url = @$link.attr('href')
    @$link.attr('href', '#')
    @init()

  init: ->
    @$link.on 'click', (e) =>
      e.preventDefault()
      @send_request()

  update: (data) ->
    if data['cookies']
      @update_count(data['cookies'])

  update_count: (count) ->
    @$link.html("StealBucket: #{count}")

  send_request: ->
    timestamp = (new Date).getMilliseconds()
    $.getJSON @url, {timestamp: "#{timestamp}"}, (data) =>
      @hunting.success(data)

