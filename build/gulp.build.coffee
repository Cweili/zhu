gulp = require('gulp')

config = require('./config')
$ = config.$
dir = config.dir

gulp.task('build', (done) ->
  process.env.NODE_ENV = 'production'
  $.runSequence(
    'del'
    'build:concurrent'
    done
  )
)

gulp.task('build:concurrent', [
  'tpl:html'
  'tpl:rollup'
  # 'webpack:build'
  'lib'
  'bin'
  'copy'
])

gulp.task('del', ->
  $.del([
    dir.dist
  ])
)

gulp.task('webpack:build', (done) ->
  require('webpack')(require('./webpack.production'), (err, stats) ->
    return done(err) if err
    $.util.log('[webpack]', stats.toString(colors: true))
    done()
  )
)

gulp.task('tpl:html', ->
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

gulp.task('lib', ->
  gulp.src("#{dir.lib}/**/*.coffee")
    .pipe($.replace(/^(.)/, '"use strict"\n$1'))
    .pipe($.coffee(bare: true)).on('error', $.util.log)
    .pipe(gulp.dest("#{dir.dist}/#{dir.lib}"))
)

gulp.task('bin', ->
  gulp.src("#{dir.bin}/**/*")
    .pipe(gulp.dest("#{dir.dist}/#{dir.bin}"))
)

gulp.task('copy', ->
  gulp.src([
    'package.json'
    'README.md'
    'LICENSE'
  ])
    .pipe(gulp.dest(dir.dist))
)
