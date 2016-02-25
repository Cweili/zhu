pkg = require('../package.json')

exports.dir =
  bin: 'bin'
  lib: 'lib'
  tpl: 'tpl'
  dist: 'dist'
  tmp: '.tmp'

exports.webpack =
  devPort: 8000

exports.$ =
  coffee: require('gulp-coffee')
  connect: require('gulp-connect')
  del: require('del')
  htmlmin: require('gulp-htmlmin')
  replace: require('gulp-replace')
  runSequence: require('run-sequence')
  uglify: require('gulp-uglify')
  util: require('gulp-util')
  vue: require('./gulp.vue')

exports.pkg = pkg
