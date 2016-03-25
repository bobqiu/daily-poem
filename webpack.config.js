var ExtractTextPlugin = require("extract-text-webpack-plugin")
var HtmlWebpackPlugin = require('html-webpack-plugin')
var webpack = require('webpack')
var path = require('path')
var Visualizer = require('webpack-visualizer-plugin')
var production = process.argv[1] == '/usr/local/bin/webpack'
var nodeModulesDir = path.resolve(__dirname, "./node_modules")
var assetFormat = "[name].[ext]"
var cssExtractor = new ExtractTextPlugin('css', "[name].css")
var knownHelpers = ['page', 'navbar', 'assetUrl', 'filledIf', 'navbarBox']
var targetDir = ''

var publicPath;
if (production) {
  publicPath = ''
} else {
  // publicPath = '/' + targetDir + '/'
  publicPath = ''
}


module.exports = {
  devtool: production ? null : 'source-map',
  entry: { all: "./src/js/main.coffee" },
  output: { path: './www/' + targetDir, filename: "[name].js", chunkFilename: "[id].js", publicPath: publicPath },

  module: {
    loaders: [
      { test: /\.css$/, loader: "style!css?sourceMap" },
      { test: /\.scss$/,
        loader: cssExtractor.extract("style", "css?sourceMap!sass?sourceMap&includePaths[]=node_modules") },
      { test: /\.hbs$/, loader: "handlebars", query: {knownHelpers: knownHelpers, inlineRequires: '^\.\.\/images\/'} }, // helperDirs: 'src/helpers'
      { test: /\.coffee$/, loaders: ['coffee']},
      { test: /\.js$/, exclude: /node_modules/, loader: 'babel?presets[]=react,presets[]=es2015' },
      { test: /\.(png|jpe?g|gif|svg)$/, loader: 'url?limit=2048&name=' + assetFormat },
      { test: /\.html$/, loader: 'file?name=[name].[ext]!html-minify'},
      { test: /\.(ttf|eot|woff2?|json?)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file?name=" + assetFormat }
    ]
  },

  plugins: [
    cssExtractor,
    // new Visualizer(),
    new HtmlWebpackPlugin({
      title: 'Custom Index', filename: 'index.html', template: 'src/index.html.ejs', inject: false, targetDir: ''
    })
  ],

  resolve: {
    extensions: ['', '.js', '.json', '.coffee', '.cjsx']
  },
  ejsHtml: { }
}
