# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  range_bars = []

  create_range_bar = (day) ->
    new_range_bar = new ElocalRangebar()

    new_range_bar.on('changing', (event, values) ->
      range = $(event.currentTarget)
      update_ranges(range)

      ranges = range.find('.elessar-range')
    )

    new_range_bar.on('change', (event, values) =>
      range = $(event.currentTarget)
      update_ranges(range)

      ranges = range.find('.elessar-range')

      console.log this.val()
    )

    range_bars.push([day, new_range_bar])

  update_ranges = (range_bar) ->
    ranges = range_bar.find('.elessar-range')

    $.each( ranges, (i, r) ->
      label = $(r).find('.elessar-barlabel')

      if $(r).width() < ($(label).width() * 1.1 )
        $(label).addClass('elessar-barlabel-raised')
      else
        $(label).removeClass('elessar-barlabel-raised')
    )


  inject_range_bar = (bar_array) ->
    title = "<span class='elessar-rangebar-title'>#{bar[0]}</span>"
    $('.slider-container').append(title)
    $('.slider-container').append(bar[1].element)

  $(document).on 'click', '.cal-grid-time-block', (event) ->
    target = $(event.currentTarget)
    if target.hasClass('open')
      target.removeClass('open')
      target.addClass('closed')
    else if target.hasClass('closed')
      target.removeClass('closed')
    else
      target.addClass('open')

  #create_range_bar(day) for day in ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  inject_range_bar(bar) for bar in range_bars


  $(document).on 'change', '#weekdays', (event) ->
    target = $(event.currentTarget)

    if target.prop('checked') == true
      console.log 'checked'
