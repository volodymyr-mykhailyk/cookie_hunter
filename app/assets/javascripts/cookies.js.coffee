class window.Cookies
  constructor: (@$div) ->
    @$link = $('#add_cookie_link')
    @url = @$link.attr('href')
    @$link.attr('href', '#')
    @init()

  init: ->
    @$link.on 'click', (e) =>
      e.preventDefault()
      @send_request(@url)

  send_request: (url) ->
    rand = Math.random()
    $.getJSON url, {rand: "#{rand}"}, (data) =>
      if data['result'] == 'success' then @success(data) else @error(data)

  success: (data) ->
    @update_count(data['cookies'])

  update_count: (count) ->
    @$link.html("Cookies: #{count}")

  error: (data) ->
    console.log 'Error'
    console.log data

$ ->
  window.cookies = new window.Cookies($('#cookies_div'))