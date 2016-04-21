ExtractTextPlugin = require('extract-text-webpack-plugin')
HtmlWebpackPlugin = require('html-webpack-plugin')
webpack = require('webpack')
path = require('path')
Visualizer = require('webpack-visualizer-plugin')

production = process.argv[1] == '/usr/local/bin/webpack'
nodeModulesDir = path.resolve(__dirname, './node_modules')
assetFormat = '[name].[ext]'
cssExtractor = new ExtractTextPlugin('css', '[name].css')
knownHelpers = ['assetUrl', 'navbarBox', 'textIf', 'textUnless']
targetDir = ''
publicPath = ''

module.exports =
  devtool: if production then null else 'source-map'
  entry: all: './src/js/main.coffee'

  output:
    path: "./www/#{targetDir}"
    filename: '[name].js'
    chunkFilename: '[id].js'
    publicPath: publicPath

  module: loaders: [
    { test: /\.css$/, loader: 'style!css?sourceMap' }
    { test: /\.scss$/, loader: cssExtractor.extract('style', 'css?sourceMap!sass?sourceMap&includePaths[]=node_modules') }
    { test: /\.hbs$/, loader: 'handlebars', query:
        knownHelpers: knownHelpers
        exclude: 'node_modules'
        helperDirs: [ "#{__dirname}/src/helpers" ]
        inlineRequires: '../images/'
    }
    { test: /\.coffee$/, loaders: [ 'coffee' ] }
    { test: /\.js$/, exclude: /node_modules/, loader: 'babel?presets[]=react,presets[]=es2015' }
    { test: /\.(png|jpe?g|gif|svg)$/, loader: "url?limit=2048&name=#{assetFormat}" }
    { test: /\.html$/, loader: 'file?name=[name].[ext]!html-minify' }
    { test: /\.(ttf|eot|woff2?|json?)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file?name=#{assetFormat}" }
  ]

  plugins: [
    cssExtractor
    new HtmlWebpackPlugin(
      title: 'Custom Index', filename: 'index.html', template: 'src/index.html.ejs', inject: false, targetDir: ''
    )
  ]

  resolve: extensions: ['', '.js', '.json', '.coffee', '.cjsx']

  ejsHtml: {}
