(function() {
  var chainable, curriedGet, getSortedKeys, _;

  _ = require('lodash');

  chainable = function(fn) {
    return function() {
      fn.apply(this, arguments);
      return this;
    };
  };

  getSortedKeys = function(obj, fromRight) {
    return _(obj).keys().sort(function(a, b) {
      return a - b;
    }).value();
  };

  curriedGet = _.curry(function(findFn, predicate) {
    var key, keys;
    if (!_.isFunction(predicate)) {
      throw new Error('Predicate expected');
    }
    keys = getSortedKeys(this.values);
    key = findFn(keys, predicate);
    return this.values[key];
  });

  exports.values = {};

  exports.set = chainable(function(data) {
    if (!_.isObject(data)) {
      throw new Error('Expected object');
    }
    this.clear();
    return this.extend(data);
  });

  exports.clear = chainable(function() {
    var key, val, _ref, _results;
    _ref = this.values;
    _results = [];
    for (key in _ref) {
      val = _ref[key];
      _results.push(delete this.values[key]);
    }
    return _results;
  });

  exports.extend = chainable(_.partial(_.extend, this.values));

  exports.add = chainable(function(key, value) {
    return this.values[key] = value;
  });

  exports.getSmallest = function() {
    return this.get(function(item) {
      return item;
    });
  };

  exports.getLargest = function() {
    return this.getRight(function(item) {
      return item;
    });
  };

  exports.getNext = function(val) {
    return this.get(function(item, index, arr) {
      return arr[index] <= item && item > val;
    });
  };

  exports.get = curriedGet(_.find);

  exports.getRight = curriedGet(_.findLast);

}).call(this);
