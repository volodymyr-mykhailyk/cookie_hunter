class window.Hunter
  constructor: (@$li) ->
    @$link = @$li.find('a.hunter_link').first()
    @url = @$link.attr('href')
    @$link.attr('href', '#')
    @id = @$link.attr('data-id')
    @email = @$link.attr('data-email')
    @init()

  init: ->
    @$link.on 'click', (e) =>
      e.preventDefault()
      @send_request()

  send_request: ->
    rand = Math.random()
    $.getJSON @url, {hunter_id: @id, rand: "#{rand}"}, (data) =>
      if data['result'] == 'success' then @success(data) else @error(data)

  success: (data) ->
    @update_count(data['cookies'])

  update_count: (count) ->
    @$link.html("#{@email} (#{count})")

  error: (data) ->
    console.log 'Error'
    console.log data



window.Hunter.init = (@$div) =>
  window.Hunter.hunters = []
  $.each $('li.hunter'), (i, li) =>
    window.Hunter.hunters.push(new Hunter($(li)))
    true

$ ->
  window.cookies = new window.Hunter.init($('#hunters_div'))