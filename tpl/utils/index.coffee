doc = document
Vue = require('vue')
util = Vue.util
extend = util.extend
toArray = util.toArray
isArray = util.isArray
utils =
  noop: ->
  clone: (collection) ->
    if isArray(collection) then collection.slice(0) else extend({}, collection)
  each: (collection, handler) ->
    if isArray(collection)
      collection.forEach(handler)
    else
      Object.keys(collection).forEach(((key) ->
        handler(collection[key], key)
      ))
  defaults: (object, source) ->
    utils.each(object, (defaultValue, prop) ->
      if source[prop] == null
        source[prop] = defaultValue
    )
  pick: (object, attrs) ->
    result = {}
    if !isArray(attrs)
      attrs = toArray(arguments).slice(1)
    utils.each(attrs, (attr) ->
      result[attr] = object[attr]
    )
    result
  drop: (array) ->
    array = array.slice(0)
    for index in toArray(arguments).slice(1)
      array.splice(index, 1, null)
    array.filter((elem) -> elem != null)
  isFunction: (fn) ->
    fn && typeof fn == 'function'
  encodeHTML: (str) ->
    div = doc.createElement('div')
    div.appendChild doc.createTextNode(str)
    div.innerHTML
  closest: (elem, selector) ->
    matchesSelector = elem.matches || elem.webkitMatchesSelector || elem.mozMatchesSelector || elem.msMatchesSelector
    while elem
      if matchesSelector.call(elem, selector)
        return elem
      elem = elem.parentElement
    null
  fireEvent: (node, eventName) ->
    # Make sure we use the ownerDocument from the provided node to avoid
    # cross-window problems
    currentDocument = undefined
    if node.ownerDocument
      currentDocument = node.ownerDocument
    else if node.nodeType == 9
      # the node may be the document itself, nodeType 9 = DOCUMENT_NODE
      currentDocument = node
    else
      throw new Error('Invalid node passed to fireEvent: ' + node.id)
    if node.dispatchEvent
      # Gecko-style approach (now the standard) takes more work
      eventClass = ''
      # Different events have different event classes.
      # If this switch statement can't map an eventName to an eventClass,
      # the event firing is going to fail.
      switch eventName
        when 'click', 'mousedown', 'mouseup'
          eventClass = 'MouseEvents'
        when 'focus', 'change', 'blur', 'select', 'submit'
          eventClass = 'HTMLEvents'
        else
          throw new Error("fireEvent: Couldn't find an event class for event '#{eventName}'.")
      _event = currentDocument.createEvent(eventClass)
      bubbles = if eventName == 'change' then false else true
      _event.initEvent(eventName, bubbles, true)
      # All events created as bubbling && cancelable.
      _event.synthetic = true
      # allow detection of synthetic events
      # The second parameter says go ahead with the default action
      node.dispatchEvent(_event, true)
    else if node.fireEvent
      # IE-old school style
      _event2 = currentDocument.createEventObject()
      _event2.synthetic = true
      # allow detection of synthetic events
      node.fireEvent('on' + eventName, _event2)
    return
module.exports = extend(utils, util)
