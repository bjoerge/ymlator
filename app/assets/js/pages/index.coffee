#= require ../libs-bundle
#= require ../ymlator
#= require ../ace

{Ymlator} = this

$ ->
  console.log("loaded")
  # Initialize the ace-based pastebin
  editor = ace.edit("pastebin")
  editor.setTheme("ace/theme/textmate")
  
  YamlMode = require("ace/mode/yaml").Mode

  editor.getSession().setMode(new YamlMode())
  editor.renderer.setShowGutter(false)
  editor.setHighlightActiveLine(false)
  editor.selectAll()

  # Form elements
  $form = $('form#add_item')
  $name = $form.find('input[name=name]')
  $description = $form.find('input[name=description]')
  $notifier = $("#notifier")
  $form.submit (e)->
    e.preventDefault()
    ymlSource = editor.getSession().getValue()
    name = $.trim($name.val())
    description = $.trim($description.val())
    return alert("No value") unless $.trim(ymlSource)

    item = value: ymlSource
    item.name = name if name
    item.description = description if description
    saved = Ymlator.ajax('POST', "/api/ymlator/v1/items", {item})
    saved.then ({item})->
      $notifier.stop(true, true)
        .removeClass('alert-error').addClass('alert-success')
        .html("""✓ Created new item with key #{item.key} """).show().fadeOut(duration: 1000*5)
      document.location.href="/items/#{item.key}/edit"

    saved.fail (xhr)->
      $notifier.stop(true, true).removeClass('alert-success').addClass('alert-error').html("""⚠ Ouch, could not submit because of <strong>#{xhr.statusText}</strong>""").show()
    false

  $name.focus()
  