page = require('webpage').create()
system = require('system')
fs = require('fs')

injects = [
  '../node_modules/lazy.js/lazy.min.js'
  '../lib/exam.js'
]

args = Array.prototype.slice.call(system.args)
args.shift() # remove self script

results = []

DEBUG = system.env.DEBUG || ''
printLogs = DEBUG.split(',')

page.settings.userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36"

print = (type, name, obj) ->
  return if printLogs.indexOf(name) < 0
  console[type](obj)


debugLog = (name, obj) ->
  print('log', name, obj)


errorLog = (name, obj) ->
  print('error', name, obj)


exit = (code) ->
  # See: https://github.com/ariya/phantomjs/issues/12697
  page.close() if (page)

  setTimeout ->
    phantom.exit(code)
  , 0

  phantom.onError = ->


toTSVString = (result) ->
  result.data
    .map (row) ->
      headers = Object.keys(result.headers)

      headers
        .map (name) ->
          type = result.headers[name]
          value = row[name]

          if type == 'string'
            "\"#{value}\""
          else
            value

        .join("\t")

    .join("\n")


page.onError = (msg, trace) ->
  #if debugLogs.contains('pageerror')
    msgStack = ['[ERROR] ' + msg]

    if trace && trace.length
      msgStack.push('TRACE:')

      trace.forEach (t) ->
        msgStack.push(" -> #{t.file}: #{t.line}" + (if t.function then " (in function #{t.function} )" else ''))

    errorLog(msgStack.join('\n'))


page.onConsoleMessage = (msg, lineNum, sourceId) ->
  debugLog('pageconsole', msg)


page.onCallback = (result) ->
  console.log toTSVString(result)


test = (url) ->
  page.open url, (status) ->
    if status != 'success'
      console.error("Fail to load the address: #{url}")
      exit(1)

    injectResult = injects.every (js) ->
      page.injectJs(js)

    if injectResult
      result = page.evaluate ->
        exam document, (result) -> window.callPhantom(result)

      setTimeout(nextTest, 1000)
    else
      errorLog('pageerror', 'Fail to inject JavaScript files.')
      exit(1)


nextTest = ->
  url = args.shift()

  if url
    test(url)
  else    
    exit(0)


nextTest()