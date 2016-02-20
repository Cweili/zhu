path = require('path')

gulp = require('gulp')

parser = require('./parser')
config = require('./config')
$ = config.$
dir = config.dir

gulp.task('b', ['build'])

gulp.task('build', (done) ->
  $.runSequence(
    'del'
    'build:concurrent'
    ->
      $.util.log("Finished build in '#{dir.dist}'")
      done()
  )
)

gulp.task('build:concurrent', [
  'markdown'
  'asset'
  'tpl'
])

gulp.task('del', ->
  $.del([
    dir.dist
  ])
)

gulp.task('markdown', (done) ->
  $.runSequence(
    'summary'
    'article'
    done
  )
)

gulp.task('article', ->
  gulp.src([
    '*/*.{md,markdown}'
    'README.{md,markdown}'
  ])
    .pipe($.marked(
      renderer: parser.articleRender
      langPrefix: 'line-numbers language-'
    ))
    .pipe($.htmlmin(
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
    .pipe(gulp.dest("#{dir.dist}/#{dir.book}"))
    .pipe($.connect.reload())
)

gulp.task('asset', ->
  gulp.src([
    '*/*'
    '!*/*.{md,markdown}'
  ])
    .pipe(gulp.dest("#{dir.dist}/#{dir.book}"))
)

gulp.task('summary', ->
  gulp.src('SUMMARY.{md,markdown}')
    .pipe($.marked(
      renderer: parser.summaryRender
    ))
    .pipe($.convert(
      from: 'xml'
      to: 'json'
    ))
    .pipe($.replace(/[\S\s\r\n]*/m, ($0) ->
      summary
      try
        summary = if $0.replace(/\s/g, '') && $0 != 'null' then parser.summary(JSON.parse($0)) else {}
      catch e
        $.util.log("Summary parse error #{e}")
        summary = {}

      summary.v = Date.now().toString(36)
      summary.title = process.cwd().split(path.sep).pop()
      JSON.stringify(summary)
    ))
    .pipe(gulp.dest("#{dir.dist}/#{dir.book}"))
    .pipe($.connect.reload())
)

gulp.task('tpl', ->
  gulp.src(path.resolve(__dirname, "../#{dir.tpl}/**/*"))
    .pipe(gulp.dest(dir.dist))
)
