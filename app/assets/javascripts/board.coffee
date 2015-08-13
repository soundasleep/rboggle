intervals = []
submitted = false

checkState = (div) ->
  return if div.dataset["finished"]    # if the game has finished, don't carry on submitting forever

  throw "no expires defined" unless div.dataset["expires"]

  seconds_left = moment(div.dataset["expires"]).diff(moment(), "seconds")

  $(".seconds-left").html seconds_left

  if seconds_left <= 0 && !submitted
    $(div).find("form").submit()
    submitted = true

applyAutoSubmit = () ->
  $("#game-board").each (i, div) ->
    intervals.push window.setInterval( () ->
        checkState(div)
      , 1 * 1000)

    checkState(div)

$(document).on 'ready page:update', ->
  intervals.forEach (interval) ->
    window.clearInterval interval

  intervals = []

  # then apply new intervals
  applyAutoSubmit()
