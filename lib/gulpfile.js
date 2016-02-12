var fs = require('fs')
var path = require('path')

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
  'article',
  'summary'
])

gulp.task('article', function() {
  return gulp.src([
    '*/*.{md,markdown}',
    'README.{md,markdown}'
  ])
    .pipe(marked({
      renderer: parser.articleRender
    }))
    .pipe(htmlmin())
    .pipe(gulp.dest(dist))
})

gulp.task('summary', function() {
  return gulp.src('SUMMARY.{md,markdown}')
    .pipe(marked({
      renderer: parser.summaryRender
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
