fs = require('fs')
path = require('path')

gulp = require('gulp')
runSequence = require('run-sequence')
del = require('del')
marked = require('gulp-marked')
htmlmin = require('gulp-htmlmin')
replace = require('gulp-replace')
convert = require('gulp-convert')
connect = require('gulp-connect')

parser = require('./parser')

dist = '_book'
book = 'book'
tpl = 'tpl'
cwd = process.cwd()

gulp.task('default', ['server'])

gulp.task('server', [
  'watch'
  'connect'
])

gulp.task('build', (done) ->
  runSequence(
    'del'
    'build:concurrent'
    done
  )
)

gulp.task('build:concurrent', [
  'markdown'
  'asset'
  'tpl'
])

gulp.task('del', ->
  del([
    dist
  ])
)

gulp.task('markdown', (done) ->
  runSequence(
    'summary'
    'article'
    done
  )
)

gulp.task('article', ->
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
    .pipe(connect.reload())
)

gulp.task('asset', ->
  gulp.src([
    '*/*'
    '!*/*.{md,markdown}'
  ])
    .pipe(gulp.dest("#{dist}/#{book}"))
)

gulp.task('summary', ->
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

      summary.v = Date.now().toString(36)
      summary.title = cwd.split(path.sep).pop()
      JSON.stringify(summary)
    ))
    .pipe(gulp.dest("#{dist}/#{book}"))
    .pipe(connect.reload())
)

gulp.task('tpl', ->
  gulp.src(path.resolve(__dirname, "../#{tpl}/**/*"))
    .pipe(gulp.dest(dist))
)

gulp.task('connect', ['build'], ->
  connect.server(
    port: 8000
    root: dist
    livereload: port: 35731
    debug: true
  )
)

gulp.task('watch', ->
  gulp.watch([
    '*/*.{md,markdown}'
    'README.{md,markdown}'
  ], ['article'])
  gulp.watch('SUMMARY.{md,markdown}', ['summary'])
)
