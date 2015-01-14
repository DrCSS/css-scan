expect = require('chai').expect
spawn = require('child_process').spawn

describe 'test.html', ->
  before (cb) ->
    program = spawn('node', [ './bin/entry.js', 'test/test.html' ])

    program.stdout.on 'data', (data) =>
      console.log data.toString()
      @result = JSON.parse(data.toString())
      cb()

    program.stderr.on 'data', (data) =>
      throw new Error(data.toString())


  it '@import rule', ->
    expect(@result.data.length).to.equal(4)