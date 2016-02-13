webpack = require('webpack')

config = require('./config')

webpackConfig = require('./webpack.base')

webpackConfig.entry = webpackConfig.entry.concat([
  'webpack/hot/dev-server'
  'webpack-hot-middleware/client?path=/__webpack_hmr&timeout=20000'
])
webpackConfig.output.filename = 'app.js'

webpackConfig.debug = true
webpackConfig.devtool = 'source-map'

webpackConfig.plugins = (webpackConfig.plugins || []).concat([
  new webpack.HotModuleReplacementPlugin()
])

module.exports = webpackConfig
