gulp = require('gulp')

config = require('./config')
$ = config.$
dir = config.dir

gulp.task('build', [
  'webpack:build'
  'html'
  'lib'
])

gulp.task('webpack:build', (done) ->
  $.webpack(require('./webpack.production'), (err, stats) ->
    return done(err) if err
    $.util.log('[webpack]', stats.toString(colors: true))
    done()
  )
)

gulp.task('html', ->
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

gulp.task('lib', ->
  gulp.src("{#{dir.bin},#{dir.lib}}/**/*")
    .pipe(gulp.dest(dir.dist))
)
