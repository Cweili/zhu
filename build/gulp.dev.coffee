gulp = require('gulp')

config = require('./config')
$ = config.$

gulp.task('dev', [
  'webpack:dev'
])

gulp.task('webpack:dev', (done) ->
  webpackConfig = require('./webpack.development')
  compiler = $.webpack(webpackConfig)
  server = new $.webpackDevServer(compiler,
    contentBase: config.dir.tpl
    hot: true
    historyApiFallback: true
    quiet: false
    noInfo: false
    stats: colors: true
  )
  server.listen(config.webpack.devPort, 'localhost', done)
)
