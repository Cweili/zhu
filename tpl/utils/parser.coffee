HASH_CHAR = require('./router').HASH_CHAR

linkParser = (content, chapter) ->
  content.replace(/(<a href=)([^\s>]+)(.*?)(<\/a>)/g, ($0, $1, $2, $3, $4) ->
    href = $2.replace(/^("?)(\.\.\/)?([^\:]+)$/, ($0, $1, $2, $3) ->
      "#{$1}#{HASH_CHAR}/#{if $2 then '' else chapter}#{$3}"
    )
    "#{$1}#{href}#{$3}#{$4}"
  )

imgParser = (content, chapter, prefix, version) ->
  content.replace(/<img src=([^\s>]+)(.*?)>/g, ($0, $1, $2) ->
    img = '<img class=img-responsive src='
    v = "?#{version}"
    if $1.indexOf('//') < 0
      img += "#{prefix}#{chapter}#{$1}#{v}#{$2}>"
    else if $1.indexOf('../') >= 0
      img += "#{$1.replace('../', '')}#{v}#{$2}>"
    else
      img += "#{$1}#{$2}>"
    img
  )

module.exports = (content, section, prefix, version) ->
  chapter = section.split('/')
  chapter = if chapter.length > 1 then chapter[0] + '/' else ''
  linkParser(imgParser(content, chapter, prefix, version), chapter)
