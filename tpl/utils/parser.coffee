utils = require('./')
toArray = utils.toArray
HASH_CHAR = require('./router').HASH_CHAR

linkParser = (content, chapter) ->
  content.replace(/(<a href=)([^\s>]+)(.*?)(>)([\S\s]+?)(<\/a>)/g, ->
    args = toArray(arguments)
    href = args[2].replace(/^("?)(\.\.\/)?([^\:]+)$/, ->
      parts = toArray(arguments)
      "#{HASH_CHAR}/#{if parts[2] then '' else chapter}#{parts[3]}"
    )
    "#{args[1]}#{href}#{args[3..6].join('')}"
  )

imgParser = (content, chapter, prefix, v) ->
  content.replace(/<img src=(.+?)( alt=.+?)?>/g, ($0, $1, $2) ->
    img = '<img class=img-responsive src='
    v = "?#{v}"
    if $1.indexOf('//') < 0
      "#{img}#{prefix}#{chapter}#{$1}#{v}#{$2}>"
    else if $1.indexOf('../') >= 0
      "#{img}#{$1.substr(3)}#{v}#{$2}>"
    else
      "#{img}#{$1}#{$2}>"
  )

module.exports = (content, section, prefix, v) ->
  chapter = section.split('/')
  chapter = if chapter.length > 1 then chapter[0] + '/' else ''
  linkParser(imgParser(content, chapter, prefix, v), chapter)
