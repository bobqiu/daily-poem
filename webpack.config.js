var ExtractTextPlugin = require("extract-text-webpack-plugin");
var HtmlWebpackPlugin = require('html-webpack-plugin');
var path = require('path')
var nodeModulesDir = path.resolve(__dirname, "./node_modules")
var assetFormat = "[name].[ext]"
var cssExtractor = new ExtractTextPlugin('css', "[name].css")

module.exports = {
  devtool: 'source-map',
  entry: { all: "./source/javascripts/application.coffee" },
  output: { path: './www/assets', filename: "[name].js", chunkFilename: "[id].js", publicPath: '' },

  module: {
    loaders: [
      { test: /\.css$/, loader: "style!css?sourceMap" },
      { test: /\.scss$/,
        loader: cssExtractor.extract("style", `css?sourceMap!sass?sourceMap&includePaths[]=${nodeModulesDir}`) },
        // loader: "style!css!sass!resolve-url" },
      { test: /\.html$/, loaders: ['file?name=' + assetFormat]},
      { test: /\.hbs$/, loader: "handlebars-loader" },
      { test: /\.coffee$/, loaders: ['coffee']},
      { test: /\.js$/, exclude: /node_modules/, loader: 'babel?presets[]=react,presets[]=es2015' },
      { test: /\.(png|jpe?g|gif)$/, loader: 'url?limit=4096&name=' + assetFormat },
      { test: /\.(ttf|eot|woff2?|svg|json?)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file?name=" + assetFormat }
    ]
  },

  plugins: [
    cssExtractor
    // new HtmlWebpackPlugin({
    //   title: 'Custom Index',
    //   filename: '../index.html',
    //   template: 'source/index.html.ejs',
    //   inject: false
    // })
  ],

  resolve: {
    extensions: ['', '.js', '.json', '.coffee', '.cjsx']
  },

  ejsHtml: {
    env: 'device',
  }
};
