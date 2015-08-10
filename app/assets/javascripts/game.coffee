intervals = []

checkState = (div) ->
  throw "no url defined" unless div.dataset["checkUrl"]

  jQuery.ajax
    url: div.dataset["checkUrl"]
    success: (data) ->
      if data.last_board && data.last_board.started?
        throw "no url defined in response" unless data.last_board.url
        window.location = data.last_board.url

      if data.players != parseInt(div.dataset["players"], 10) || data.players_ready != parseInt(div.dataset["playersReady"], 10)
        window.location = data.url

    error: (xhr, status, error) ->
      console.error error

waitForGameToStart = () ->
  $("#wait-for-game-to-start").each (i, div) ->
    intervals.push window.setInterval( () ->
        checkState(div)
      , 1 * 1000)

$(document).on 'ready page:update', ->
  intervals.forEach (interval) ->
    window.clearInterval interval

  intervals = []

  # then apply new intervals
  waitForGameToStart()
