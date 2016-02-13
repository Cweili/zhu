pkg = require('../package.json')

exports.dir =
  bin: 'bin'
  lib: 'lib'
  tpl: 'tpl'
  dist: 'dist'

exports.webpack =
  devPort: 8000

exports.$ =
  coffee: require('gulp-coffee')
  connect: require('gulp-connect')
  del: require('del')
  htmlmin: require('gulp-htmlmin')
  replace: require('gulp-replace')
  util: require('gulp-util')
  webpack: require('webpack')
  webpackDevMiddleware: require('webpack-dev-middleware')
  webpackHotMiddleware: require('webpack-hot-middleware')

exports.pkg = pkg
