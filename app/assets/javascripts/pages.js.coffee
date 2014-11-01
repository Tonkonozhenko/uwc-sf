# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  select = $('#bonus_plus_search_type')
  $('.select2able').select2({
    width: '100%'
  })
#  $.ajax
#    url: '/types.json'
#    success: (data) ->
#      debugger
#      data.forEach (d) ->
#        select.append($('<option>', {
#          value: d
#        }).html(d))


  office_search_form = $('#office-search-from')
  no_results = $('#no_results')
  table = $('#results')

  office_search_form.on 'ajax:success', (event, data) ->
    table.html('
          <tr>
            <th>City</th>
            <th>Address</th>
            <th>Name</th>
            <th>Phone</th>
            <th>Email</th>
          </tr>')

    data.pages.forEach (office) ->
      tr = $('<tr>')
      .append($('<td>').html(office.city))
      .append($('<td>').html(office.address))
      .append($('<td>').html(office.name))
      .append($('<td>').html(office.phone))
      .append($('<td>').html(office.email))

      table.append tr

    if data.pages.length == 0
      table.addClass('hidden')
      no_results.removeClass('hidden')
    else
      table.removeClass('hidden')
      no_results.addClass('hidden')

  bonus_plus_search_form = $('#bonus-plus-search-from')
  bonus_plus_search_form.on 'ajax:success', (event, data) ->
    table.html('
          <tr>
            <th>City</th>
            <th>Address</th>
            <th>Bonus</th>
            <th>type</th>
          </tr>')

    data.pages.forEach (bonus_plus) ->
      tr = $('<tr>')
      .append($('<td>').html(bonus_plus.city))
      .append($('<td>').html(bonus_plus.address))
      .append($('<td>').html(bonus_plus.bonus_plus))
      .append($('<td>').html(bonus_plus.type))

      table.append tr

    if data.pages.length == 0
      table.addClass('hidden')
      no_results.removeClass('hidden')
    else
      table.removeClass('hidden')
      no_results.addClass('hidden')