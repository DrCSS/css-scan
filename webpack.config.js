var webpack = require('webpack');
var path = require('path');

module.exports = {
  entry: ['./src/css-scan'],

  output: {
    filename: 'dist/css-scan.js'
  },

  module: {
    loaders: [
      { test: /\.coffee$/, loader: 'coffee' }
    ]
  },

  resolve: {
    extensions: ["", ".js", ".coffee"],
    root: [
      path.join(__dirname, 'src')
    ]
  }
};