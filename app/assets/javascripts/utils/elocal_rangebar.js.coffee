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

  changing: (event, values) =>
    range = $(event.currentTarget)
    @update_ranges(range)

    ranges = range.find('.elessar-range')

  changed: (event, values) =>
    range = $(event.currentTarget)
    @update_ranges(range)

    ranges = range.find('.elessar-range')

    console.log @object.val()

  update_ranges: (range_bar) =>
    ranges = range_bar.find('.elessar-range')

    $.each( ranges, (i, r) ->
      label = $(r).find('.elessar-barlabel')

      if $(r).width() < ($(label).width() * 1.1 )
        $(label).addClass('elessar-barlabel-raised')
      else
        $(label).removeClass('elessar-barlabel-raised')
    )
