#!/usr/bin/env node

'use strict'

var path = require('path')
var cwd = process.cwd()
var argv = process.argv

argv.push('--cwd')
argv.push(cwd)

argv.push('--gulpfile')
argv.push(path.resolve(__dirname, '../lib/index.js'))

require('gulp/bin/gulp')
