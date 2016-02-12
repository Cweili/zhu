var fs = require('fs')
var path = require('path')

var gulp = require('gulp')
var del = require('del')
var marked = require('gulp-marked')
var htmlmin = require('gulp-htmlmin')
var replace = require('gulp-replace')
var convert = require('gulp-convert')

var parser = require('./parser')

var dist = '_book'
var book = 'book'
var tpl = 'tpl'
var version = Date.now().toString(36)
var cwd = process.cwd()

gulp.task('build', [
  'article',
  'asset',
  'tpl'
])

gulp.task('del', function() {
  return del([
    dist
  ])
})

gulp.task('article', ['summary'], function() {
  return gulp.src([
    '*/*.{md,markdown}',
    'README.{md,markdown}'
  ])
    .pipe(marked({
      renderer: parser.articleRender,
      langPrefix: 'line-numbers language-'
    }))
    .pipe(htmlmin({
      collapseWhitespace: true,
      removeAttributeQuotes: true,
      removeComments: true,
      removeCommentsFromCDATA: true,
      removeScriptTypeAttributes: true,
      removeStyleLinkTypeAttributes: true,
      useShortDoctype: true,
      minifyJS: true,
      minifyCSS: true
    }))
    .pipe(gulp.dest(dist + '/' + book))
})

gulp.task('asset', ['del'], function() {
  return gulp.src([
    '*/*',
    '!*/*.{md,markdown}'
  ])
    .pipe(gulp.dest(dist + '/' + book))
})

gulp.task('summary', ['del'], function() {
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
    .pipe(gulp.dest(dist + '/' + book))
})

gulp.task('tpl', ['del'], function() {
  return gulp.src(path.resolve(__dirname, '../' + tpl, '**/*'))
    .pipe(gulp.dest(dist))
})
