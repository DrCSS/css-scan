Lazy = require('lazy.js')
inspectors = require('inspectors')
wrapArray = require('utils/wrap-array')

module.exports =
  inspect: (doc, finished) ->
    fi = setInterval ->
      sheets = wrapArray(document.styleSheets)
      isRulesLoaded = sheets.every (sheet) -> sheet.cssRules

      if isRulesLoaded
        console.log "==== Loaded StyleSheet#cssRules"
        clearInterval(fi)

        result = {}

        Lazy(inspectors).each (inspector, name) ->
          result[name] = inspector.inspect(document)

        finished(result)
    , 10
