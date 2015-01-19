inspectors = require('inspectors')

module.exports =
  inspect: (doc, finished) ->
    fi = setInterval ->
      sheets = toArray(document.styleSheets)
      isRulesLoaded = sheets.every (sheet) -> sheet.cssRules

      if isRulesLoaded
        console.log "==== Loaded StyleSheet#cssRules"
        clearInterval(fi)

        result = {}

        inspectors.forEach (inspector, name) ->
          result[name] = inspector.inspect(document)

        finished(result)
    , 10