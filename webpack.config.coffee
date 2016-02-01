ngAnnotatePlugin = require 'ng-annotate-webpack-plugin'
module.exports = 
  
  entry: './src/example.coffee'
  devtool: 'source-map'
  watch: true
  output:
    filename: 'bundle.js'
    path: './dist/'

  module: 
    loaders: [
      { test: /\.coffee$/, loader: 'coffee' }
      { test: /\.css$/, loader:  "style!css?sourceMap"}
      { test: /\.scss$/, loaders: ["style", "css?sourceMap", "sass?sourceMap"]}
    # ,
      # { test: /\.js$/, loader: 'jsx-loader?harmony' } 
    ]
  plugins: [
    new ngAnnotatePlugin
      add: true
  # ,
    # new HtmlWebpackPlugin()
  ,
  ]  
  resolve: 
    extensions: ['', '.js', '.json', '.coffee']