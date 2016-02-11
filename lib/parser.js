'use strict'

function summaryParser(node, s) {
  if (s.a) {
    node.title = s.a[0]._
    node.link = s.a[0].href[0].replace(/\.(md|markdown)$/i, '')
  }
  if (s.ul && s.ul[0] && s.ul[0].li) {
    node.sections = s.ul[0].li.map(function(a) {
      return summaryParser({}, a);
    })
  } else if (s.ul && s.ul && s.ul.li) {
    node.sections = s.ul.li.map(function(a) {
      return summaryParser({}, a);
    })
  }
  return node;
}

exports.summary = function(s) {
  return summaryParser({}, s)
}
