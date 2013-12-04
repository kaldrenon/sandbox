# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $(document).ready ->
    $('body').prepend('<h4 style="display: none;">Sandbox</h4>')
    $('h4').show(500)
    # Run once at first load
    apply_select()


  window.apply_select = (scope = '.sandbox') ->
    $("#{scope} select.select2-test").select2({
      placeholder: "Select a category",
      allowClear: true
    }).change( (e) ->
      console.log(e)
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
    )
    $('.cat-select').removeAttr('tabindex')

  #
  # Toggle provided approval button
  #
  window.set_approve = (container, enabled) ->
    btn = $(container).find('.sc-approve-btn')
    if enabled
      $(btn).removeAttr('disabled')
    else
      $(btn).attr('disabled','')


