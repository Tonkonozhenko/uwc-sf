# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  office_search_form = $('#office-search-from')
  office_search_no_results = $('#no_results')
  office_search_table = $('#results')

  office_search_form.on 'ajax:success', (event, data) ->
    office_search_table.html('
      <tr>
        <th>City</th>
        <th>Address</th>
        <th>Name</th>
        <th>Phone</th>
        <th>Email</th>
      </tr>')

    data.forEach (office) ->
      tr = $('<tr>')
      .append($('<td>').html(office.city))
      .append($('<td>').html(office.address))
      .append($('<td>').html(office.name))
      .append($('<td>').html(office.phone))
      .append($('<td>').html(office.email))

      office_search_table.find('tbody').append tr

    if data.length == 0
      office_search_table.addClass('hidden')
      office_search_no_results.removeClass('hidden')
    else
      office_search_table.removeClass('hidden')
      office_search_no_results.addClass('hidden')