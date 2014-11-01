# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('.select2able').select2({
    width: '100%'
  })

  office_search_form = $('#office-search-from')
  no_results = $('#no_results')
  table = $('#results')
  next = $('#next')
  previous = $('#previous')

  links = (form) ->
    current = parseInt(form.find('[name=page]').val())
    if current == 1
      previous.addClass('hidden')
    else
      previous.removeClass('hidden')
    next.removeClass('hidden')

  next.on 'click', (e) ->
    form = $ $(@).data('target')
    page = form.find('[name=page]')
    current = parseInt page.val()
    page.val(current + 1)
    form.submit()
    e.preventDefault()

  previous.on 'click', (e) ->
    form = $ $(@).data('target')
    page = form.find('[name=page]')
    current = parseInt page.val()
    page.val(current - 1)
    form.submit()
    e.preventDefault()

  office_search_form.on 'ajax:success', (event, data) ->
    links(office_search_form)

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
    links(bonus_plus_search_form)

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