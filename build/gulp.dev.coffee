gulp = require('gulp')

config = require('./config')
$ = config.$
dir = config.dir

gulp.task('dev', [
  'connect'
])

gulp.task('connect', ->
  webpackConfig = require('./webpack.development')
  compiler = require('webpack')(webpackConfig)
  $.connect.server(
    port: 8000
    root: dir.tpl
    debug: true
    middleware: ->
      [
        require('webpack-dev-middleware')(compiler,
          noInfo: false
          quiet: false
          lazy: false
          stats: colors: true
        )
        require('webpack-hot-middleware')(compiler,
          log: $.util.log
          path: '/__webpack_hmr'
          heartbeat: 10 * 1000
        )
      ]
  )
)
