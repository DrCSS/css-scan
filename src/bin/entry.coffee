spawn = require('child_process').spawn
path = require('path')

phantom = path.join(__dirname, './phantomjs')
script = path.join(__dirname, './phantom.js')
phantomProcess = spawn(phantom, [ '--web-security=no', script ].concat(process.argv.slice(2)))

phantomProcess.stdout.on 'data', (data) ->
  console.log(data.toString())

phantomProcess.stderr.on 'data', (data) ->
  console.error(data.toString())
