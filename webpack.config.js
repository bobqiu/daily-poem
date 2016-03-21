var ExtractTextPlugin = require("extract-text-webpack-plugin");
var HtmlWebpackPlugin = require('html-webpack-plugin');
var path = require('path')
var nodeModulesDir = path.resolve(__dirname, "./node_modules")
var assetFormat = "[name].[ext]"
var cssExtractor = new ExtractTextPlugin('css', "[name].css")
var targetDir = 'bundle'
var knownHelpers = ['page', 'navbar']

module.exports = {
  devtool: 'source-map',
  entry: { all: "./src/js/main.coffee" },
  output: { path: './www/' + targetDir, filename: "[name].js", chunkFilename: "[id].js", publicPath: '' },

  module: {
    loaders: [
      { test: /\.css$/, loader: "style!css?sourceMap" },
      { test: /\.scss$/,
        loader: cssExtractor.extract("style", "css?sourceMap!sass?sourceMap&includePaths[]=node_modules") },
      { test: /\.hbs$/, loader: "handlebars-loader", query: {knownHelpers: knownHelpers} }, // helperDirs: 'src/helpers'
      { test: /\.coffee$/, loaders: ['coffee']},
      { test: /\.js$/, exclude: /node_modules/, loader: 'babel?presets[]=react,presets[]=es2015' },
      { test: /\.(png|jpe?g|gif|svg)$/, loader: 'url?limit=2048&name=' + assetFormat },
      { test: /\.html$/, loader: 'file?name=[name].[ext]!html-minify'},
      { test: /\.(ttf|eot|woff2?|json?)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file?name=" + assetFormat }
    ]
  },

  plugins: [
    cssExtractor,
    new HtmlWebpackPlugin({
      title: 'Custom Index', filename: '../index.html', template: 'src/index.html.ejs', inject: false,
      targetDir: ''
    })
  ],

  resolve: {
    extensions: ['', '.js', '.json', '.coffee', '.cjsx']
  },

  ejsHtml: { env: 'device', targetDir: targetDir + '/' }
}