module.exports = (lodash) ->
  extensions =

    # extends _.omit, allowing omission of deep nested items, includinng on array
    # _.omitPaths {a:1, b:[{c:2, d:3}, {c:4, d:5}]}, 'b.c'  ==>>>  {a:1, b:[{d:3}, {d:5}]}
    omitPaths: (obj, paths...) ->
      paths = lodash.map paths, (p) -> p.split '.'
      o = lodash.omit obj, lodash.map(paths, (p) -> lodash.first p)
      paths = lodash.select paths, (p) -> p.length > 1
      if paths.length
        pathObj = lodash.groupBy paths, (p) -> lodash.first p
        lodash.each pathObj, (omissions, key) ->
          if lodash.isArray obj[key]
            o[key] = []
            lodash.each obj[key], (item) ->
              o[key].push lodash.omitPaths item, lodash.map(omissions, (o) -> o.slice(1).join '.')...
          else
            o[key] = lodash.omitPaths obj[key], lodash.map(omissions, (o) -> o.slice(1).join '.')...
      o

    # clone object, replacing the specified elemnts
    # _.replacePaths {a:1, b:{{c:2, d:3}}}, 'b.c':99  ==>>>  {a:1, b:{c:99, d:3}}
    #
    # TODO: replacement for array is currently repeated on each element.
    #       would be more useful to replace each element if the replacement is also an array
    #
    replacePaths: (obj, paths) ->
      o = lodash.omitPaths obj, lodash.keys(paths)...

      replace = (o, key, replacement) ->
        keys = key.split '.'
        if keys.length is 1
          o[keys[0]] = replacement
        else if lodash.isArray o[keys[0]]
          lodash.each o[keys[0]], (item) ->
            replace item, keys.slice(1).join('.'), replacement
        else
          replace o[keys[0]], keys.slice(1).join('.'), replacement

      lodash.each paths, (replacement, key) ->
        replace o, key, replacement
      o

  lodash.mixin extensions

