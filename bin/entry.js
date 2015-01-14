#!/usr/bin/env node
var path, phantom, phantomProcess, script, spawn;

spawn = require('child_process').spawn;

path = require('path');

phantom = path.join(__dirname, './phantomjs');

script = path.join(__dirname, './phantom.js');

phantomProcess = spawn(phantom, ['--web-security=no', script].concat(process.argv.slice(2)));

phantomProcess.stdout.on('data', function(data) {
  return console.log(data.toString());
});

phantomProcess.stderr.on('data', function(data) {
  return console.error(data.toString());
});
