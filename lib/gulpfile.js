var fs = require('fs')
var path = require('path')

var Renderer = require('marked').Renderer

var gulp = require('gulp')
var marked = require('gulp-marked')
var htmlmin = require('gulp-minify-html')
var replace = require('gulp-replace')
var convert = require('gulp-convert')

var parser = require('./parser')

var dist = '_book'
var version = Date.now().toString(36)
var cwd = process.cwd()

gulp.task('build', [
  'marked',
  'summary'
])

gulp.task('marked', function() {
  var renderer = new Renderer()
  renderer.link = function(href, title, text) {
    var out = '<a href="' + href.replace(/([^\:]+?)(\/?)([^\:]*?)\.(md|markdown)$/, '$1$2$3.html') + '"'
    if (title) {
      out += ' title="' + title + '"'
    }
    out += '>' + text + '</a>'
    return out
  }
  return gulp.src([
    '*/*.{md,markdown}',
    'README.{md,markdown}'
  ])
    .pipe(marked({
      renderer: renderer
    }))
    .pipe(htmlmin())
    .pipe(gulp.dest(dist))
})

gulp.task('summary', function() {
  var renderer = new Renderer()
  renderer.heading = function() {
    return ''
  }
  return gulp.src('SUMMARY.{md,markdown}')
    .pipe(marked({
      renderer: renderer
    }))
    .pipe(convert({
      from: 'xml',
      to: 'json'
    }))
    .pipe(replace(/[\S\s\r\n]*/m, function($0) {
      var summary
      try {
        summary = parser.summary(JSON.parse($0))
      } catch (e) {
        console.error(e, e)
        summary = {}
      }

      summary.v = version
      summary.title = cwd.split(path.sep).pop()
      return JSON.stringify(summary)
    }))
    .pipe(gulp.dest(dist))
})
