path = require('path')
rollup = require('rollup')
coffee = require('rollup-plugin-coffee-script')
commonjs = require('rollup-plugin-commonjs')
nodeResolve = require('rollup-plugin-node-resolve')
vue = require('rollup-plugin-vue')

config = require('./config')
dir = config.dir

module.exports = rollup.rollup(
  entry: "#{dir.tpl}/#{config.pkg.name}.vue"
  plugins: [
    nodeResolve(
      jsnext: true
      main: true
    )
    commonjs(
      include: 'node_modules/**'
      extensions: [
        '.js'
        '.coffee'
      ]
    )
    vue()
    coffee()
  ]
)
  .then((bundle) ->
    bundle.write(
      dest: "#{dir.tpl}/#{config.pkg.name}.js"
      format: 'iife'
      # sourceMap: 'inline'
    )
  )
