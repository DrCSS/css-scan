toArray = (arrayLikeObject) ->
  Array.prototype.slice.call(arrayLikeObject)

getPropertyValueCounts = (doc) ->
  styleSheets = Lazy(toArray(doc.styleSheets))
  console.log 'styleSheets', styleSheets.toArray()

  getRules = (groupingRule) ->
    rules = groupingRule.pluck('cssRules').map(toArray).flatten()
    importSheets = rules.pluck('styleSheet').compact() # @import

    console.log 'importSheets', importSheets.toArray()

    if importSheets.size() > 0
      return rules.concat(getRules(importSheets))

    rules

  rules = getRules(styleSheets)
  plainStyles = rules.pluck('style')
  atRuleStyles = getRules(rules).pluck('style')
  styles = plainStyles.concat(atRuleStyles).compact()

  declarations =
    styles
      .map (style) ->
        props = toArray(style)
        Lazy(props)
          .map (p) ->
            { property: p, value: style[p] }
          .toArray()
      .flatten()

  propertyValueCounts =
    declarations
      .groupBy('property')
      .map (props, prop) ->
        values = Lazy(props).pluck('value').uniq().toArray()

        property: prop
        valueCount: values.length

      .sortBy('valueCount')

  console.log 'rules.size', rules.size()
  console.log 'plainStyles.size', plainStyles.size()
  console.log 'atRuleStyles.size', atRuleStyles.size()
  console.log 'styles.size', styles.size()
  console.log 'propertyValueCounts.size', propertyValueCounts.size()

  headers:
    property: 'string'
    valueCount: 'integer'
  data: propertyValueCounts.toArray()
  location:
    hostname: window.location.hostname
    pathname: window.location.pathname


exam = (doc, finished) ->
  fi = setInterval ->
    sheets = toArray(document.styleSheets)
    isRulesLoaded = sheets.every (sheet) -> sheet.cssRules

    if isRulesLoaded
      console.log "==== Loaded StyleSheet#cssRules"
      clearInterval(fi)
      finished(getPropertyValueCounts(document))
  , 10
