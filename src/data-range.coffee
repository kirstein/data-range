_ = require 'lodash'

# Wraps the input element in a function that always returns chainable result
chainable = (fn) -> ->
  fn.apply @, arguments
  @

# Find all sorted keys of the array
getSortedKeys = (obj, fromRight) ->
  _(obj).keys()
        .sort (a, b) -> a - b
        .value()

# All defined values
exports.values = {}

# Replace all the values with input one
exports.set = chainable (data) ->
  throw new Error 'Expected object' unless _.isObject data
  @clear()
  @extend data

# Clear all the values while keeping the reference
exports.clear = chainable -> delete @values[key] for key, val of @values

# Assign all values from inputs to values
# Will override all duplicates keys with the new args
exports.extend = chainable _.partial _.extend, @values

# Add the current key to list
exports.add = chainable (key, value) ->
  @values[key] = value

# Returns the next OR same value from the list
exports.getNext = (val) ->
  @get (item, index, arr) ->
    arr[index] <= item and item >= val

# Returns the first value that matches the given predicate
exports.get = (predicate) ->
  throw new Error 'Predicate expected' unless _.isFunction predicate
  keys = getSortedKeys @values
  key  = _.find keys, predicate
  @values[key]
