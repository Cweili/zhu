'use strict'

var path = require('path')
var cwd = process.cwd()

process.argv.push('--cwd')
process.argv.push(cwd)

process.argv.push('--gulpfile')
process.argv.push(path.resolve(__dirname, '../lib/gulpfile.js'))

require('gulp/bin/gulp')
