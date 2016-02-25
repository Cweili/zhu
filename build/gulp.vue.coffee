through = require('through2')
gutil = require('gulp-util')

PluginError = gutil.PluginError

PLUGIN_NAME = 'gulp-vueify'

module.exports = (options) ->
  compiler = require('vueify').compiler

  through.obj((file, encode, callback) ->
    if file.isNull()
      return callback(null, file)

    if file.isStream()
      @emit('error', new PluginError(PLUGIN_NAME, 'Streams are not supported'))
      return callback()

    if options
      compiler.applyConfig(options)

    compiler.compile(file.contents.toString(), file.path, (err, result) =>
      if err
        @emit('error', new PluginError(PLUGIN_NAME, err.message))
        return callback()

      file.path = gutil.replaceExtension(file.path, '.js')
      file.contents = new Buffer(result)
      callback(null, file)
    )
  )
