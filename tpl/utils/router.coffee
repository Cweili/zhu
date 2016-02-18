utils = require('./')
noop = utils.noop
each = utils.each
nextTick = utils.nextTick

win = window
HASH_CHAR = '#'

_routes = []
_params = []
_hash = ''
befores = []
afters = []

router = exports

currentPath = -> win.location.hash.substr(HASH_CHAR.length)
go = (path) -> win.location.hash = HASH_CHAR + path
onChange = ->
  path = currentPath()
  hashIndex = path.lastIndexOf('#')
  if hashIndex > -1
    _hash = path.substr(hashIndex + 1)
    path = path.substr(0, hashIndex)
  else
    _hash = ''
  each(_routes, (r) ->
    route = r.route
    if route.test(path)
      fns = befores.concat([r.fn]).concat(afters).concat([noop])
      _params = route.exec(path).slice(1)
      fns.reduce((current, next) ->
        if current && current(_params) != false then next else false
      )

      # 滚动到 hash 对应 id
      if _hash
        nextTick(-> setTimeout(->
          if _hash
            el = document.getElementById(_hash)
            window.scrollTo(0, el.offsetTop - 20) if el
        , 300))
      false
  )

router.on = (routes) ->
  each(routes, (fn, route) ->
    _routes.push(
      route: new RegExp('^' + route.replace(/\//g, '\/') + '$')
      fn: fn
    )
  )

  currentPath() || go('/')

  win.onhashchange = onChange
  onChange()

router.install = (Vue) ->
  Vue.prototype.$router = go: go
  Object.defineProperties(Vue.prototype.$router,
    path: get: currentPath
    hash: get: -> _hash
    params: get: -> _params
  )

  Vue.directive('href', update: (href) ->
    @el.href = HASH_CHAR + href
  )

router.before = (before) ->
  befores.push(before)

router.after = (after) ->
  afters.push(after)
