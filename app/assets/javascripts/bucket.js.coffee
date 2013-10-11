class window.StealBucket
  constructor: (@$div) ->
    @$link = $('#get_steal_bucket_link')
    @url = @$link.attr('href')
    @$link.attr('href', '#')
    @init()

  init: ->
    @$link.on 'click', (e) =>
      e.preventDefault()
      @send_request()

  send_request: ->
    rand = Math.random()
    $.getJSON @url, {rand: "#{rand}"}, (data) =>
      if data['result'] == 'success' then @success(data) else @error(data)

  success: (data) ->
    @update_count(data['steal_bucket_cookies'])
    if data['hunter_cookies']
      window.cookies.update_count(data['hunter_cookies'])

  update_count: (count) ->
    @$link.html("StealBucket: #{count}")

  error: (data) ->
    console.log 'Error'
    console.log data

$ ->
  window.steal_bucket = new window.StealBucket($('#cookies_div'))