webpack = require('webpack')
path = require('path')

module.exports =
  entry: ['./src/css-scan']

  output:
    filename: 'css-scan.js'

  module:
    loaders: [
      { test: /\.coffee$/, loader: 'coffee' }
    ]

  resolve:
    extensions: ["", ".js", ".coffee"]
    root: [
      path.join(__dirname, 'src')
    ]