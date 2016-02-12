'use strict'

var Renderer = require('marked').Renderer
var summaryRender = new Renderer()
var articleRender = new Renderer()

function summaryParser(node, s) {
  var list;
  if (s.a) {
    node.title = s.a[0]._
    node.link = s.a[0].href[0].replace(/\.(md|markdown)$/i, '')
  }
  if (s.ul) {
    if (s.ul[0] && s.ul[0].li) {
      list = s.ul[0].li
    } else if (s.ul && s.ul.li) {
      list = s.ul.li
    }
    node.list = list.map(function(a) {
      return summaryParser({}, a);
    })
  }
  return node;
}

articleRender.heading = function(text, level) {
  return (level < 2 ? '<div class="page-header">' : '')
    + '<h'
    + level
    + '>'
    + text
    + '</h'
    + level
    + '>'
    + (level < 2 ? '</div>' : '')
}

articleRender.table = function(header, body) {
  return '<div class="table-responsive">'
    + '<table class="table table-bordered table-striped">'
    + '<thead>'
    + header
    + '</thead>'
    + '<tbody>'
    + body
    + '</tbody>'
    + '</table>'
    + '</div>'
}

articleRender.link = function(href, title, text) {
  var out = '<a href="' + href.replace(/([^\:]+?)(\/?)([^\:]*?)\.(md|markdown)$/, '$1$2$3.html') + '"'
  if (title) {
    out += ' title="' + title + '"'
  }
  out += '>' + text + '</a>'
  return out
}

summaryRender.heading = function() {
  return ''
}

exports.articleRender = articleRender
exports.summaryRender = summaryRender

exports.summary = function(s) {
  return summaryParser({}, s)
}
