Renderer = require('marked').Renderer
summaryRender = new Renderer()
articleRender = new Renderer()

articleRender.heading = (text, level) ->
  (if level < 2 then '<div class="page-header">' else '') +
  "<h#{level}>#{text}</h#{level}>" +
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
  href.replace(/([^\:]+?)(\/?)([^\:]*?)\.(md|markdown)$/, '$1$2$3.html') +
  '"' +
  (if title then ' title="' + title + '"' else '') +
  ">#{text}</a>"

summaryRender.heading = -> ''

exports.articleRender = articleRender
exports.summaryRender = summaryRender

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
