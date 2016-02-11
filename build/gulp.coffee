fs = require('fs')
gulp = require('gulp')

for file in fs.readdirSync(__dirname)
  if /^gulp\..*\.coffee/.test(file)
    require("./#{file}")

gulp.task('default', ['dev'])
