utils = require('./')
noop = utils.noop
isObject = utils.isObject
methods = [
  'get'
  'post'
  'put'
  'delete'
]
befores = []
afters = []

parseJson = (json) ->
  try
    return JSON.parse(json)
  catch e
    return json

ajax = (method, url, data, options, onSuccess, onError) ->
  xhr = new ((window.XMLHttpRequest || window.ActiveXObject))('Microsoft.XMLHTTP')

  xhr.onreadystatechange = ->
    if xhr.readyState == 4
      last = if xhr.status >= 200 && xhr.status < 400 then onSuccess else onError
      afters.concat([
        last
        noop
      ]).reduce((current, next) ->
        if current && current(parseJson(xhr.responseText), xhr, options) != false then next else false
      )

  xhr.open(method, url, true)
  if data
    if /POST|PUT/.test(method)
      xhr.setRequestHeader('Content-type', 'application/json')
      data = JSON.stringify(data)
    else
      data = undefined
  xhr.send(data)

transformUrl = (url, data) ->
  pattern = /\/:(\w+)/g
  encode = encodeURIComponent
  if isObject(data)
    return url.replace(pattern, ($0, $1) ->
      if data[$1] == null then '' else '/' + encode(data[$1])
    )
  url.replace pattern, ->
    if data == null then '' else '/' + encode(data)

http = module.exports = (url) ->
  options = if arguments.length <= 1 || arguments[1] == undefined then {} else arguments[1]
  fns = {}
  methods.forEach((method) ->
    fns[method] = (data, onSuccess, onFailed) ->
      if typeof data == 'function'
        onFailed = onSuccess
        onSuccess = data
      method = method.toUpperCase()
      requestUrl = transformUrl(url, data)

      last = -> ajax(
        method
        requestUrl
        data
        options
        onSuccess
        onFailed
      )

      befores.concat([
        last
        noop
      ]).reduce((current, next) ->
        if current && current(
          requestUrl
          data
          method
          options
          onSuccess
          onFailed
        ) != false then next else false
      )
  )
  fns

http.before = (before) ->
  befores.push(before)

http.after = (after) ->
  afters.push(after)
