exports.dir =
  dist: '_book'
  book: 'book'
  tpl: 'tpl'

exports.$ =
  runSequence: require('run-sequence')
  convert: require('gulp-convert')
  connect: require('gulp-connect')
  del: require('del')
  marked: require('gulp-marked')
  htmlmin: require('gulp-htmlmin')
  replace: require('gulp-replace')
  util: require('gulp-util')
