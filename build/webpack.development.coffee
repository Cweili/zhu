webpack = require('webpack')

config = require('./config')

webpackConfig = require('./webpack.base')

webpackConfig.entry = webpackConfig.entry.concat([
  "webpack-dev-server/client?http://localhost:#{config.webpack.devPort}"
  'webpack/hot/dev-server'
])
webpackConfig.output.filename = 'app.js'

webpackConfig.debug = true
webpackConfig.devtool = 'source-map'

webpackConfig.plugins = (webpackConfig.plugins || []).concat([
  new webpack.HotModuleReplacementPlugin()
])

module.exports = webpackConfig
