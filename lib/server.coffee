gulp = require('gulp')

config = require('./config')
$ = config.$
dir = config.dir

gulp.task('s', ['server'])

gulp.task('server', [
  'watch'
  'connect'
])

gulp.task('connect', ['build'], ->
  $.connect.server(
    port: 8000
    root: dir.dist
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
