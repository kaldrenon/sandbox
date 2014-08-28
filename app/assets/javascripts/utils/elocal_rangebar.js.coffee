#
# A jQuery plugin functioning as a wrapper to quarterto/Elessar
#
# Adds some necessities and control niceness, adds some eLocal-specific requirements
#

$=jQuery
jQuery.fn.elocalRangebar = (options = {})-> @each (i, element) -> new ElocalRangebar(element, options)

class ElocalRangebar
  constructor: (element, options) ->
    options   = @mergeOptionsWithDefaults(options)
    @object   = new RangeBar(options)
    @object.on('change', @changed)
    @object.on('changing', @changing)

    @rangebar = $(@object.$el)

    @element  = $(element)
    @element.data 'elocalRangebar', this

    @element.append(@rangebar)

  # Fires during all intervals of the change process (slide/drag/etc)
  changing: (event, values) =>
    @update_ranges()

  # Fires when a change cycle is over (user releases mouse, etc)
  changed: (event, values) =>
    @update_ranges()

  # Modify the values and CSS classes of all ranges as needed
  update_ranges: () =>
    @raise_barlabels(@rangebar.find('.elessar-range'))
    @add_connector_to_adjacent_ranges()

  # Raise up barlabels for bars that are too small
  raise_barlabels: (ranges) ->
    $.each( ranges, (i, r) ->
      label = $(r).find('.elessar-barlabel')

      if $(r).width() < ($(label).width() * 1.1 )
        $(label).addClass('elessar-barlabel-raised')
      else
        $(label).removeClass('elessar-barlabel-raised')
    )

  add_connector_to_adjacent_ranges: () =>
    @rangebar.find('.elessar-range').removeClass('elessar-left-neighbor')
    $('.elessar-merge-button').remove()

    pairs = @object.val()
    $.each( pairs, (i, pair) =>
      if (pairs[i + 1] != undefined) && @are_adjacent(pair, pairs[i + 1])
        console.log this
        console.log @rangebar
        console.log @rangebar.find('.elessar-range')
        $(@rangebar.find('.elessar-range')[i]).addClass('elessar-left-neighbor')
    )

    $.each(@rangebar.find('.elessar-left-neighbor').find('.elessar-handle'), (i, handle) ->
      if (i % 2) == 1
        $(handle).append("<div class='elessar-merge-button'><i class='icon-plus text-success' /></div>")
    )

  # Determine if two ranges are adjacent
  are_adjacent: (pair_one, pair_two) ->
    pair_one[1] == pair_two[0]

  merge_adjacent: (values, index_left) ->
    values[index_left] = [values[index_left[0]], values[index_left + 1][1]]
    values = values.slice(0, index_left + 1).concat(values.slice(index_left + 2, values.length))
    @rangebar.val(values)

  mergeOptionsWithDefaults: (options) =>
    defaults = {
      min: moment().startOf('day').format('LLLL'),
      max: moment().startOf('day').add(1, 'day').format('LLLL'),
      snap: 1000 * 60 * 15,
      minSize: 1000 * 60 * 15,
      allowDelete: true,
      deleteTimeout: 1000,
      valueFormat: (ts) ->
        return moment(ts).format('LLLL')
      ,
      valueParse: (date) ->
        return moment(date).valueOf()
      ,
      values: [
        [
          moment().startOf('day').add(8, 'hours').format('LLLL'),
          moment().startOf('day').add(17, 'hours').format('LLLL')
        ]
      ],
      label: (a) ->
        return "#{moment(a[0]).format('hh:mm A')} - #{moment(a[1]).format('hh:mm A')}"
      ,
      bgMarks: {
        count: 24,
        interval: 1000 * 60 * 60
        label: '|'
      }
    }

    (options[key] = defaults[key] if options[key] == undefined) for key in Object.keys(defaults)

    return options

