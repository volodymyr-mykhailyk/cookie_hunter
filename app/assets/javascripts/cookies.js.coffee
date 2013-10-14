class window.Cookies
  constructor: (@$div) ->
    @$link = $('#add_cookie_link')
    @url = @$link.attr('href')
    @$link.attr('href', '#')
    @init()
    window.setInterval( (=> @update()), 10000)

  init: ->
    @$link.on 'click', (e) =>
      e.preventDefault()
      @send_request(@url)

  send_request: (url) ->
    timestamp = (new Date).getMilliseconds()
    $.getJSON url, {timestamp: "#{timestamp}"}, (data) =>
      if data['result'] == 'success' then @success(data) else @error(data)

  success: (data) ->
    @update_count(data['cookies'])
    if data['steal_bucket_cookies']
      window.steal_bucket.update_count(data['steal_bucket_cookies'])

  update_count: (count) ->
    @$link.html("Cookies: #{count}")

  error: (data) ->
    console.log 'Error'
    console.log data

  update: ->
    @send_request('/cookies')

$ ->
  window.cookies = new window.Cookies($('#cookies_div'))