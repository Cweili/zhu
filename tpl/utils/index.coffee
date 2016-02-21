doc = document
Vue = require('vue')
util = Vue.util
extend = util.extend
toArray = util.toArray
isArray = util.isArray
utils =
  noop: ->
  clone: (collection) ->
    if isArray(collection) then collection[0..] else extend({}, collection)
  each: (collection, handler) ->
    if isArray(collection)
      for e, i in collection
        return if handler(e, i) == false
    else
      for k, v of collection
        return if handler(v, k) == false
  defaults: (object, source) ->
    utils.each(object, (defaultValue, prop) ->
      if source[prop] == null
        source[prop] = defaultValue
    )
  pick: (object, attrs) ->
    result = {}
    if !isArray(attrs)
      attrs = toArray(arguments)[1..]
    utils.each(attrs, (attr) ->
      result[attr] = object[attr]
    )
    result
  timehash: -> Date.now().toString(36)
module.exports = extend(utils, util)
