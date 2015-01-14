var DEBUG, args, debugLog, errorLog, exit, fs, injects, nextTest, page, print, printLogs, results, system, test, toTSVString;

page = require('webpage').create();

system = require('system');

fs = require('fs');

injects = ['../node_modules/lazy.js/lazy.min.js', '../lib/exam.js'];

args = Array.prototype.slice.call(system.args);

args.shift();

results = [];

DEBUG = system.env.DEBUG || '';

printLogs = DEBUG.split(',');

page.settings.userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36";

print = function(type, name, obj) {
  if (printLogs.indexOf(name) < 0) {
    return;
  }
  return console[type](obj);
};

debugLog = function(name, obj) {
  return print('log', name, obj);
};

errorLog = function(name, obj) {
  return print('error', name, obj);
};

exit = function(code) {
  if (page) {
    page.close();
  }
  setTimeout(function() {
    return phantom.exit(code);
  }, 0);
  return phantom.onError = function() {};
};

toTSVString = function(result) {
  return result.data.map(function(row) {
    var headers;
    headers = Object.keys(result.headers);
    return headers.map(function(name) {
      var type, value;
      type = result.headers[name];
      value = row[name];
      if (type === 'string') {
        return "\"" + value + "\"";
      } else {
        return value;
      }
    }).join("\t");
  }).join("\n");
};

page.onError = function(msg, trace) {
  var msgStack;
  msgStack = ['[ERROR] ' + msg];
  if (trace && trace.length) {
    msgStack.push('TRACE:');
    trace.forEach(function(t) {
      return msgStack.push((" -> " + t.file + ": " + t.line) + (t["function"] ? " (in function " + t["function"] + " )" : ''));
    });
  }
  return errorLog(msgStack.join('\n'));
};

page.onConsoleMessage = function(msg, lineNum, sourceId) {
  return debugLog('pageconsole', msg);
};

page.onCallback = function(result) {
  return console.log(toTSVString(result));
};

test = function(url) {
  return page.open(url, function(status) {
    var injectResult, result;
    if (status !== 'success') {
      console.error("Fail to load the address: " + url);
      exit(1);
    }
    injectResult = injects.every(function(js) {
      return page.injectJs(js);
    });
    if (injectResult) {
      result = page.evaluate(function() {
        return exam(document, function(result) {
          return window.callPhantom(result);
        });
      });
      return setTimeout(nextTest, 1000);
    } else {
      errorLog('pageerror', 'Fail to inject JavaScript files.');
      return exit(1);
    }
  });
};

nextTest = function() {
  var url;
  url = args.shift();
  if (url) {
    return test(url);
  } else {
    return exit(0);
  }
};

nextTest();
