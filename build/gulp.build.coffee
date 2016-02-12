gulp = require('gulp')

config = require('./config')
$ = config.$
dir = config.dir

gulp.task('build', [
  'webpack:build'
  'html'
  'lib'
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
    .pipe($.htmlmin())
    .pipe(gulp.dest("#{dir.dist}/#{dir.tpl}"))
)

gulp.task('lib', ['del'], ->
  gulp.src([
    "{#{dir.bin},#{dir.lib}}/**/*"
    "package.json"
    "README.md"
    "LICENSE"
  ])
    .pipe(gulp.dest(dir.dist))
)
