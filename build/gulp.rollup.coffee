gulp = require('gulp')

config = require('./config')
$ = config.$
dir = config.dir

rollup = require('rollup').rollup
nodeResolve = require('rollup-plugin-node-resolve')
commonjs = require('rollup-plugin-commonjs')

dest = "#{dir.dist}/#{dir.tpl}/#{config.pkg.name}.js"

gulp.task('tpl:rollup', ['tpl:bundle'], ->
  gulp.src(dest)
    .pipe($.uglify()).on('error', $.util.log)
    .pipe(gulp.dest("#{dir.dist}/#{dir.tpl}"))
)

gulp.task('tpl:rollup', [
  'tpl:vue'
  'tpl:script'
], ->
  rollup({
    entry: "#{dir.tmp}/index.js"
    plugins: [
      nodeResolve(
        jsnext: true
        main: true
        browser: true
      )
      commonjs()
    ],
    onwarn: $.util.log
  })
    .then((bundle) ->
      bundle.write(
        dest: dest
        format: 'iife'
        moduleName: config.pkg.name
      )
    )
)

gulp.task('tpl:vue', (done) ->
  gulp.src("#{dir.tpl}/**/*.vue")
    .pipe($.vue()).on('error', $.util.log)
    .pipe(gulp.dest(dir.tmp))
)

gulp.task('tpl:script', ->
  gulp.src("#{dir.tpl}/**/*.coffee")
    .pipe($.coffee(bare: true)).on('error', $.util.log)
    .pipe(gulp.dest(dir.tmp))
)
