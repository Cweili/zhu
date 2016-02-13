gulp = require('gulp')

config = require('./config')
$ = config.$
dir = config.dir

gulp.task('build', [
  'webpack:build'
  'html'
  'lib'
  'copy'
])

gulp.task('del', ->
  $.del([
    '${dir.dist}'
  ])
)

gulp.task('webpack:build', ['del'], (done) ->
  $.webpack(require('./webpack.production'), (err, stats) ->
    return done(err) if err
    $.util.log('[webpack]', stats.toString(colors: true))
    done()
  )
)

gulp.task('html', ['del'], ->
  gulp.src("#{dir.tpl}/*.html")
    .pipe($.replace('@@build.name', config.pkg.name))
    .pipe($.replace('@@build.version', config.pkg.version))
    .pipe($.replace(
      /<script src="(\S+?)"><\/script>/
      """<script src="$1?#{config.pkg.version}"><\/script>"""
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
    .pipe(gulp.dest("#{dir.dist}/#{dir.tpl}"))
)

gulp.task('lib', ['del'], ->
  gulp.src("#{dir.lib}/**/*.coffee")
    .pipe($.replace(/^(.)/, '"use strict"\n$1'))
    .pipe($.coffee(bare: true)).on('error', $.util.log)
    .pipe(gulp.dest("#{dir.dist}/#{dir.lib}"))
)

gulp.task('copy', ['del'], ->
  gulp.src([
    "#{dir.bin}/**/*"
    "package.json"
    "README.md"
    "LICENSE"
  ])
    .pipe(gulp.dest(dir.dist))
)
