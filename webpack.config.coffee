ExtractTextPlugin = require('extract-text-webpack-plugin')
HtmlWebpackPlugin = require('html-webpack-plugin')
webpack = require('webpack')
path = require('path')
Visualizer = require('webpack-visualizer-plugin')

nodeModulesDir = path.resolve(__dirname, './node_modules')
assetFormat = '[name].[ext]'
cssExtractor = new ExtractTextPlugin('css', '[name].css')
knownHelpers = ['assetUrl', 'navbarBox', 'textIf', 'textUnless']

production = process.argv[1] == '/usr/local/bin/webpack'
release = process.env.RELEASE


targetDir = ''
publicPath = ''
sourcePrefix = if release then '' else 'http://10.0.1.3:3000/'

module.exports =
  devtool: if production then null else 'source-map'
  entry:
    app: './src/js/main.coffee'
    lib: './src/js/lib.coffee'
    spec: './spec/spec.co'

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
    { test: /\.(coffee|co)$/, loaders: [ 'coffee' ] }
    { test: /\.js$/, exclude: /node_modules/, loader: 'babel' } # presets[]=react,presets[]=es2015
    { test: /\.(png|jpe?g|gif|svg)$/, loader: "url?limit=1024&name=#{assetFormat}" }
    { test: /\.html$/, loader: 'file?name=[name].[ext]!html-minify' }
    { test: /\.(ttf|eot|woff2?|json?)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file?name=#{assetFormat}" }
  ]

  plugins: [
    cssExtractor
    new HtmlWebpackPlugin(
      title: 'Custom Index', filename: 'index.html', template: 'src/index.html.ejs', inject: false, targetDir: sourcePrefix
    )
    new HtmlWebpackPlugin(
      title: 'Test Index', filename: 'test.html', template: 'src/test.html.ejs', inject: false, targetDir: sourcePrefix
    )
  ]

  resolve:
    root: path.resolve(__dirname)
    alias:
      ext: "lib/js"
    extensions: ['', '.js', '.json', '.coffee', '.co', '.cjsx']

  ejsHtml: {}
