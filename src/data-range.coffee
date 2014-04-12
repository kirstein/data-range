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

# Find the result by finding the key first from the sorted array
# If no result to the key is found then will return undefined
#
# Will throw if the predicate is not a function
curriedGet = _.curry (findFn, predicate) ->
  throw new Error 'Predicate expected' unless _.isFunction predicate
  keys = getSortedKeys @values
  key  = findFn keys, predicate
  @values[key]

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

# Returns the smallest value
exports.getSmallest = ->
  @get (item) -> item

# Returns the biggest value
exports.getLargest = ->
  @getRight (item) -> item

# Returns the next value each time
# If there is no next value will return undefined
exports.getNext = (val) ->
  @get (item, index, arr) ->
    arr[index] <= item and item > val

# Returns the first result that matches the given parameter
# The search function will search from the left to right
exports.get = curriedGet _.find

# Same as get, only searches from right to left
exports.getRight = curriedGet _.findLast
