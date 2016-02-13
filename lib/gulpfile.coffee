fs = require('fs')
path = require('path')

gulp = require('gulp')
del = require('del')
marked = require('gulp-marked')
htmlmin = require('gulp-htmlmin')
replace = require('gulp-replace')
convert = require('gulp-convert')

parser = require('./parser')

dist = '_book'
book = 'book'
tpl = 'tpl'
version = Date.now().toString(36)
cwd = process.cwd()

gulp.task('default', ['build'])

gulp.task('build', [
  'article'
  'asset'
  'tpl'
])

gulp.task('del', ->
  del([
    dist
  ])
)

gulp.task('article', ['summary'], ->
  return gulp.src([
    '*/*.{md,markdown}'
    'README.{md,markdown}'
  ])
    .pipe(marked(
      renderer: parser.articleRender
      langPrefix: 'line-numbers language-'
    ))
    .pipe(htmlmin(
      collapseWhitespace: true
      removeAttributeQuotes: true
      removeComments: true
      removeCommentsFromCDATA: true
      removeScriptTypeAttributes: true
      removeStyleLinkTypeAttributes: true
      useShortDoctype: true
      minifyJS: true
      minifyCSS: true
    ))
    .pipe(gulp.dest("#{dist}/#{book}"))
)

gulp.task('asset', ['del'], ->
  gulp.src([
    '*/*'
    '!*/*.{md,markdown}'
  ])
    .pipe(gulp.dest("#{dist}/#{book}"))
)

gulp.task('summary', ['del'], ->
  return gulp.src('SUMMARY.{md,markdown}')
    .pipe(marked(
      renderer: parser.summaryRender
    ))
    .pipe(convert(
      from: 'xml'
      to: 'json'
    ))
    .pipe(replace(/[\S\s\r\n]*/m, ($0) ->
      summary
      try
        summary = parser.summary(JSON.parse($0))
      catch e
        console.error(e, e)
        summary = {}

      summary.v = version
      summary.title = cwd.split(path.sep).pop()
      JSON.stringify(summary)
    ))
    .pipe(gulp.dest("#{dist}/#{book}"))
)

gulp.task('tpl', ['del'], ->
  gulp.src(path.resolve(__dirname, "../#{tpl}**/*"))
    .pipe(gulp.dest(dist))
)
