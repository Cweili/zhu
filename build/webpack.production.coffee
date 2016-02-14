webpack = require('webpack')

config = require('./config')

webpackConfig = require('./webpack.base')

webpackConfig.output.chunkFilename = '[id].js?[chunkhash]'

webpackConfig.plugins = (webpackConfig.plugins || []).concat([
  # this allows uglify to strip all warnings
  # from Vue.js source code.
  new webpack.DefinePlugin(
    'process.env':
      NODE_ENV: '"production"'
  )
  # This minifies not only JavaScript, but also
  # the templates (with html-minifier) and CSS (with cssnano)!
  new webpack.optimize.UglifyJsPlugin(
    sourceMap: false,
    compress:
      warnings: false
  )
  new webpack.optimize.MinChunkSizePlugin(
    minChunkSize: 30000
  )
  new webpack.optimize.CommonsChunkPlugin(
    children: true
    minChunks: 3
  )
  # new webpack.optimize.AggressiveMergingPlugin(
  #   minSizeReduce: 1.5
  # )
])

module.exports = webpackConfig
