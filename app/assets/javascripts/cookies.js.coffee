class window.Cookies
  constructor: (@hunting, @$div) ->
    @$link = $('#add_cookie_link')
    @url = @$link.attr('href')
    @$link.attr('href', '#')
    @init()

  init: ->
    @$link.on 'click', (e) =>
      e.preventDefault()
      @send_request(@url)

  update: (data) ->
    if data['cookies']
      @update_count(data['cookies'])

  update_count: (count) ->
    @$link.html("Cookies: #{count}")

  send_request: (url) ->
    timestamp = (new Date).getMilliseconds()
    $.getJSON url, {timestamp: "#{timestamp}"}, (data) =>
      @hunting.success(data)


