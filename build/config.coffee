pkg = require('../package.json')

exports.dir =
  tpl: 'tpl'
  dist: 'dist'

exports.webpack =
  devPort: 8000

exports.$ =
  webpack: require('webpack')
  webpackDevServer: require('webpack-dev-server')
