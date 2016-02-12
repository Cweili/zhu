pkg = require('../package.json')

exports.dir =
  bin: 'bin'
  lib: 'lib'
  tpl: 'tpl'
  dist: 'dist'

exports.webpack =
  devPort: 8000

exports.$ =
  htmlmin: require('gulp-minify-html')
  replace: require('gulp-replace')
  util: require('gulp-util')
  webpack: require('webpack')
  webpackDevServer: require('webpack-dev-server')

exports.pkg = pkg
