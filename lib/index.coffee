gulp = require('gulp')

require('./build')
require('./server')

gulp.task('default', ['server'])
