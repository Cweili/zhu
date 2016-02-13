gulp = require('gulp')

config = require('./config')
$ = config.$
dir = config.dir

gulp.task('dev', [
  'connect'
])

gulp.task('connect', ->
  webpackConfig = require('./webpack.development')
  compiler = $.webpack(webpackConfig)
  $.connect.server(
    port: 8000
    root: dir.tpl
    middleware: ->
      [
        $.webpackDevMiddleware(compiler,
          noInfo: false
          quiet: false
          lazy: false
          stats: colors: true
        )
        $.webpackHotMiddleware(compiler,
          log: $.util.log
          path: '/__webpack_hmr'
          heartbeat: 10 * 1000
        )
      ]
  )
)
