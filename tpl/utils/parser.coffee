HASH_CHAR = require('./router').HASH_CHAR

linkParser = (content, chapter) ->
  content.replace(/(<a href=)([^\s>]+)(.*?)(<\/a>)/g, ($0, $1, $2, $3, $4) ->
    href = $2.replace(/^("?)(\.\.\/)?([^\:]+)$/, ($0, $1, $2, $3) ->
      "#{$1}#{HASH_CHAR}/#{if $2 then '' else chapter}#{$3}"
    )
    "#{$1}#{href}#{$3}#{$4}"
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
