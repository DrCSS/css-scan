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

    propertyValueCounts.toArray()
