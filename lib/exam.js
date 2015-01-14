var exam, getPropertyValueCounts, toArray;

toArray = function(arrayLikeObject) {
  return Array.prototype.slice.call(arrayLikeObject);
};

getPropertyValueCounts = function(doc) {
  var atRuleStyles, declarations, getRules, plainStyles, propertyValueCounts, rules, styleSheets, styles;
  styleSheets = Lazy(toArray(doc.styleSheets));
  console.log('styleSheets', styleSheets.toArray());
  getRules = function(groupingRule) {
    var importSheets, rules;
    rules = groupingRule.pluck('cssRules').map(toArray).flatten();
    importSheets = rules.pluck('styleSheet').compact();
    console.log('importSheets', importSheets.toArray());
    if (importSheets.size() > 0) {
      return rules.concat(getRules(importSheets));
    }
    return rules;
  };
  rules = getRules(styleSheets);
  plainStyles = rules.pluck('style');
  atRuleStyles = getRules(rules).pluck('style');
  styles = plainStyles.concat(atRuleStyles).compact();
  declarations = styles.map(function(style) {
    var props;
    props = toArray(style);
    return Lazy(props).map(function(p) {
      return {
        property: p,
        value: style[p]
      };
    }).toArray();
  }).flatten();
  propertyValueCounts = declarations.groupBy('property').map(function(props, prop) {
    var values;
    values = Lazy(props).pluck('value').uniq().toArray();
    return {
      property: prop,
      valueCount: values.length
    };
  }).sortBy('valueCount');
  console.log('rules.size', rules.size());
  console.log('plainStyles.size', plainStyles.size());
  console.log('atRuleStyles.size', atRuleStyles.size());
  console.log('styles.size', styles.size());
  console.log('propertyValueCounts.size', propertyValueCounts.size());
  return {
    headers: {
      property: 'string',
      valueCount: 'integer'
    },
    data: propertyValueCounts.toArray(),
    location: {
      hostname: window.location.hostname,
      pathname: window.location.pathname
    }
  };
};

exam = function(doc, finished) {
  var fi;
  return fi = setInterval(function() {
    var isRulesLoaded, sheets;
    sheets = toArray(document.styleSheets);
    isRulesLoaded = sheets.every(function(sheet) {
      return sheet.cssRules;
    });
    if (isRulesLoaded) {
      console.log("==== Loaded StyleSheet#cssRules");
      clearInterval(fi);
      return finished(getPropertyValueCounts(document));
    }
  }, 10);
};
