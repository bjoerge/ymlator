Ymlator = {}

methodOverride = (method, params, headers) ->
  unless method == 'GET' || method == 'POST'
    headers ||= {}
    headers["X-Http-Method-Override"] = method
    params ||= {}
    params['_method'] = method
    method = 'POST'
  [method, params, headers]

Ymlator.ajax = (method, url, params, headers) ->
  [method, params, headers] = methodOverride(method, params, headers)
  $.ajax
    url: url
    type: method
    dataType: 'json'
    headers: headers
    data: params

@Ymlator = Ymlator # export to global/window for now