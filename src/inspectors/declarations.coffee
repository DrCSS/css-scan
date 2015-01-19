Lazy = require('lazy.js')

gerRules = (groupingRule) ->
  # CSSStyleSheet や GroupingRule (At-Rules) に内包されているルールを取得
  rules = groupingRule.pluck('cssRules').map(wrapArray).flatten()

  # @import ルールを探す
  importSheets = rules.pluck('styleSheet').compact()

  if importSheets.size() > 0
    # @import ルールが 1 つ以上見つかった場合は、
    # インポートするスタイルシート内のルールも結果に含める
    return rules.concat(getRules(importSheets))

  rules

module.exports =
  inspect: (doc) ->
    styleSheets = Lazy(wrapArray(doc.styleSheets))
    console.log 'styleSheets', styleSheets.toArray()

    rules = getRules(styleSheets)
    plainStyles = rules.pluck('style')
    atRuleStyles = getRules(rules).pluck('style')
    styles = plainStyles.concat(atRuleStyles).compact()

    declarations =
      styles
        .map (style) ->
          props = wrapArray(style)
          Lazy(props)
            .map (p) ->
              { property: p, value: style[p] }
            .toArray()
        .flatten()

    declarations