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
      { test: /\.coffee$/, loader: 'coffee-loader' },
    # ,
      # { test: /\.js$/, loader: 'jsx-loader?harmony' } 
    ]
  plugins: [
    new ngAnnotatePlugin
      add: true
  ,
  ]  
  resolve: 
    extensions: ['', '.js', '.json', '.coffee']