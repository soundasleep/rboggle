# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

intervals = []

checkState = (div) ->
  throw "no expires defined" unless div.dataset["expires"]

  seconds_left = moment(div.dataset["expires"]).diff(moment(), "seconds")

  $(".seconds-left").html seconds_left

  if seconds_left <= 0
    $(div).find("form").submit()

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
