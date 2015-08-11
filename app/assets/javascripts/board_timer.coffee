$(document).on 'ready page:update', ->
  $(".timer").each (i, timer) ->
    $(timer).TimeCircles {
      direction: "Counter-clockwise"
      total_duration: 60 * 3
      fg_width: 0.4
      use_background: false
      time:
        Days:
          show: false
        Hours:
          show: false
        Minutes:
          show: false
        Seconds:
          color: "#234078"
          show: true
    }

