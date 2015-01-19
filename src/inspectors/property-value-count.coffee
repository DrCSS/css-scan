wrapArray = require('utils/wrap-array')
declarations = require('inspectors/declarations')

module.exports =
  inspect: (doc) ->
    declarations = declarations.inspect(doc)

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

    propertyValueCounts.toArray()
