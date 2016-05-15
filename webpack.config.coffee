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

appTheme = process.env.THEME ? 'material'

targetDir = ''
publicPath = ''
sourcePrefix = if release then '' else 'http://10.0.1.3:3000/'

module.exports =
  devtool: if production then null else 'source-map'
  entry:
    app: './src/main.cofe'
    app_ios: './src/css/main-ios.sass'
    app_material: './src/css/main-material.sass'
    lib: './src/lib.cofe'

  output:
    path: "./www/#{targetDir}"
    filename: '[name].js'
    chunkFilename: '[id].js'
    publicPath: publicPath

  module: loaders: [
    { test: /\.css$/, loader: 'style!css?sourceMap' }
    { test: /\.(scss|sass)$/, loader: cssExtractor.extract('style', 'css?sourceMap!sass?sourceMap&includePaths[]=node_modules') }
    { test: /\.hbs$/, loader: 'handlebars', query:
        knownHelpers: knownHelpers
        exclude: 'node_modules'
        helperDirs: [ "#{__dirname}/src/helpers" ]
        inlineRequires: '../images/'
    }
    { test: /\.(coffee|cofe)$/, loaders: [ 'coffee' ] }
    { test: /\.js$/, exclude: /node_modules/, loader: 'babel' } # presets[]=react,presets[]=es2015
    { test: /\.(png|jpe?g|gif|svg)$/, loader: "url?limit=1024&name=#{assetFormat}" }
    { test: /\.html$/, loader: 'file?name=[name].[ext]!html-minify' }
    { test: /\.(ttf|eot|woff2?|json?)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file?name=#{assetFormat}" }
  ]

  plugins: [
    cssExtractor
    new HtmlWebpackPlugin title: 'Custom Index', filename: 'index.html', \
      template: 'src/html/layouts/index.html.ejs', inject: false, targetDir: sourcePrefix
    new HtmlWebpackPlugin title: 'Test Index', filename: 'test.html', \
      template: 'src/html/layouts/test.html.ejs', inject: false, targetDir: sourcePrefix
    new webpack.DefinePlugin APP_THEME: JSON.stringify(appTheme)
  ]

  resolve:
    root: path.resolve(__dirname)
    alias:
      ext: "lib/js"
    extensions: ['', '.js', '.json', '.coffee', '.cofe', '.cjsx']

  ejsHtml: {}

module.exports.entry.spec = './spec/spec.cofe' unless release
