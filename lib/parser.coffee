Renderer = require('marked').Renderer

###
# articleRender
###
exports.articleRender = articleRender = new Renderer()

articleRender.heading = (text, level) ->
  id = text?.replace(/[^A-Za-z0-9]/g, '-').replace(/\-+/g, '-').replace(/(^\-)|(\-$)/g, '')
  (if level < 2 then '<div class="page-header">' else '') +
  "<h#{level}" +
  (if id then " id=\"#{id}\"" else '') +
  ">#{text}</h#{level}>" +
  (if level < 2 then '</div>' else '')

articleRender.table = (header, body) ->
  '<div class="table-responsive">\
    <table class="table table-bordered table-striped">\
      <thead>' + header + '</thead>\
      <tbody>' + body + '</tbody>\
    </table>\
  </div>'

articleRender.link = (href, title, text) ->
  '<a href="' +
  href.replace(/([^\:]+?)(\/?)([^\:]*?)\.(md|markdown)(#\S+?)?$/, '#/$1$2$3$5') +
  '"' +
  (if title then ' title="' + title + '"' else '') +
  ">#{text}</a>"

###
# summaryRender
###
exports.summaryRender = summaryRender = new Renderer()

summaryRender.heading = -> ''

###
# summaryParser
###
summaryParser = (node, s) ->
  list
  if s.a
    node.title = s.a[0]._
    node.link = s.a[0].href[0].replace(/\.(md|markdown)$/i, '')
  if s.ul
    if s.ul[0]?.li
      list = s.ul[0].li
    else if s.ul?.li
      list = s.ul.li
    node.list = list.map((a) -> summaryParser({}, a))
  node
exports.summary = (s) -> summaryParser({}, s)
