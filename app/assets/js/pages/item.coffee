#= require ../libs-bundle
#= require ../ymlator

setProperty = (obj, pathstr, val)->
  parts = pathstr.split(".")
  for part, i in parts
    last = i == parts.length - 1
    obj = obj[part] ||= (if last then val else {})

{Ymlator} = this

$ ->
  $notifier = $('#notifier')
  key = $('#item_key').val()
  $('form').on 'change', (e)->
    e.preventDefault()
    $input = $(e.target)

    value = {}
    property = $input.attr("name")
    setProperty(value, property, $input.val())

    save = Ymlator.ajax("PUT", "/api/ymlator/v1/items/#{key}", item: {value})

    save.then ->
      $notifier.stop(true, true).removeClass('alert-error').addClass('alert-success')
        .html("""✓ Saved "<i>#{property}</i>" """).show().fadeOut(duration: 1000*5)

    save.fail (xhr)->
      $notifier.stop(true, true).removeClass('alert-success').addClass('alert-error')
      .html("""⚠ Ouch, could not save: #{property} because of <strong>#{xhr.statusText}</strong>""")
      .show()
    false