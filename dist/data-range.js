(function() {
  var chainable, getSortedKeys, _;

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

  exports.getNext = function(val) {
    return this.get(function(item, index, arr) {
      return arr[index] <= item && item >= val;
    });
  };

  exports.get = function(predicate) {
    var key, keys;
    if (!_.isFunction(predicate)) {
      throw new Error('Predicate expected');
    }
    keys = getSortedKeys(this.values);
    key = _.find(keys, predicate);
    return this.values[key];
  };

}).call(this);
