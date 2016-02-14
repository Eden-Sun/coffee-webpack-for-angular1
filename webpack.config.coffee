ngAnnotatePlugin = require 'ng-annotate-webpack-plugin'
module.exports = 
  entry: ['./src/example.coffee', 'file?name=index.html!jade-html!./src/index.jade']
  devtool: 'source-map'
  output:
    filename: 'bundle.js'
    path: './dist/'

  module: 
    loaders: [
      {test: /\.coffee$/, loader:'coffee?sourceMap' }
      {test: /\.css$/, loader:  "style!css?sourceMap"}
      {test: /\.scss$/, loaders: ["style", "css?sourceMap", "sass?sourceMap"]}
      {test: /\.jade$/, loaders: [ "jade-html?sourceMap"]}
    ]
  plugins: [ new ngAnnotatePlugin add: true ]
  resolve: 
    extensions: ['', '.js', '.json', '.coffee']