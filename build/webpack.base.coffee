path = require('path')
webpack = require('webpack')

config = require('./config')
dir = config.dir

module.exports =
  entry: [
    "./#{dir.tpl}/index.coffee"
  ]
  output:
    filename: "#{config.pkg.name}.js"
    path: path.resolve(__dirname, "../#{dir.dist}/#{dir.tpl}")
    publicPath: '/'
  module:
    loaders: [
      {
        test: /\.vue$/
        loader: 'vue'
      }
      {
        test: /\.coffee$/
        loader: 'coffee'
        exclude: /node_modules/
      }
      {
        test: /\.(png|jpg|gif)$/
        loader: 'url'
        query:
          limit: 10000,
          name: '[name].[ext]?[hash]'
      }
      {
        test: /\.svg(\?\S*)?$/
        loader: 'url'
        query:
          limit: 10000,
          name: '[name].[ext]?[hash]'
          mimetype: 'image/svg+xml'
      }
      {
        test: /\.(woff|woff2|eot|ttf)(\?\S*)?$/
        loader: 'url'
        query:
          limit: 10000,
          name: '[name].[ext]?[hash]'
          mimetype: 'application/font-woff'
      }
    ]
  resolve:
    root: [
      "./#{dir.tpl}"
      './node_modules'
    ]
    extensions: ' .vue .coffee .js .styl .css'.split(' ')
  vue:
    autoprefixer:
      browsers: [
        'last 3 versions',
        'Android > 1',
        'iOS > 4',
        'ie 9',
        '> 1%'
      ]
    html: conservativeCollapse: false
