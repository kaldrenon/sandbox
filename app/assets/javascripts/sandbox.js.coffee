# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $(document).ready ->
    $('body').prepend('<h4 style="display: none;">Sandbox</h4>')
    $('h4').show(500)
    # Run once at first load
    apply_select('.select2-test')

  #
  # Email Validation UI
  #
  $(document).on 'change', '.email-address', (event) ->
    $('.alerts').hide().html($(event.currentTarget).val()).show('slow')

    $('.alerts').load('/')

  #
  # Select2 Manipulation
  #
  window.apply_select = (sel_class, ids = [], scope = '.sandbox') ->
    # If no ids given, apply to all.
    if ids.length == 0
      $("#{scope} select#{sel_class}").each( () ->
        ids.push(this.id)
      )

    # Cycle through chosen ids, apply rules.
    $.each(ids, (index, id) ->
      $("#{scope} select#{sel_class}##{id}").select2({
        placeholder: "Select a category",
        allowClear: true
      }).change( (e) ->
        console.log(e)
        # Option 1: Manage data through select2-container div
        update_select_container(e)

        # Option 2: Use old updater
        # old_update_method(e)
      )

      $("#{sel_class}##{id}").removeAttr('tabindex')
      $("#{sel_class}##{id}").addClass('sel2-done')
    )

  #
  # Update the visual and data attributes of the select2-container from the current selection
  #
  window.update_select_container = (event) ->
    # target is in a generated element and is a neighbor of select2-container
    target = event.currentTarget
    console.log target

    # VISUAL
    parent = $(target).parent().find('div.select2-container')
    parent.addClass('changed')

    if event.added
      # DATA
      # get id and name from target
      id = $(event.added.element[0]).data('id')
      val = $(event.added.element[0]).val()

      console.log "#{id}, #{val}"
      # put them in parent
      $(parent).attr('data-id', id)
      $(parent).attr('data-val', val)
    else
      $(parent).removeClass('changed')
      $(parent).attr('data-id', '0')
      $(parent).attr('data-val', 'none')



  window.old_update_method = (e) ->
    if(e.added)
      # Visual updates target the containing div, which will apply style to its children
      parent = $(e.currentTarget).parent().find('div')
      parent.addClass('changed')

      # Data updates are applied to containing div as well
      # TODO: What is element[0].attributes?
      parent.attr('data-id', e.added.element[0].attributes['data-id'].value)
      console.log("Data ID: #{parent.attr('data-id')}")
      set_approve($(e.currentTarget).closest('.cat-tr'), true)

    else
      $(e.currentTarget).removeClass('changed')
      set_approve($(e.currentTarget).closest('.cat-tr'), false)
