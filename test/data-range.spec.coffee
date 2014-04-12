mod    = require "#{process.cwd()}/src/data-range"
_      = require 'lodash'
assert = require 'assert'

describe 'data-range', ->
  afterEach -> mod.clear()

  it 'should exist', -> mod.should.be.ok

  describe '#set', ->
    it 'should throw if value is not an object', ->
      (-> mod.set null).should.throw 'Expected object'

    it 'should set values to given object', ->
      mod.set 'test': 123
      mod.values.should.eql 'test': 123

  describe '#add', ->
    it 'should add values to list', ->
      mod.add 'hello', 132
      mod.values.hello.should.eql 132

    it 'should be chainable', ->
      mod.add().should.eql mod

  describe '#clear', ->
    it 'should keep the reference', ->
      ref = mod.values
      mod.clear()
      mod.values.should.equal ref

    it 'should clear all the values', ->
      mod.add 0, 'key1'
      mod.clear()
      _.isEmpty(mod.values).should.eql true

    it 'should be chainable', ->
      mod.clear().should.eql mod

  describe '#extend', ->
    it 'should add values to list', ->
      mod.extend 'hello2' : 132
      mod.values.hello2.should.eql 132

    it 'should be chainable', ->
      mod.extend().should.eql mod

  describe '#getNext', ->
    it 'should return the next value', ->
      mod.add 0, 'key1'
      mod.add 2, 'key2'
      mod.getNext(1).should.eql 'key2'

    it 'should work with floating nrs', ->
      mod.add .2, 'key1'
      mod.add .4, 'key2'
      mod.getNext(.3).should.eql 'key2'

    it 'should return the not same value if next is the same', ->
      mod.add 2, 'key2'
      mod.add 0, 'key1'
      mod.getNext(0).should.eql 'key2'

    it 'should return undefined if the value does not exist', ->
      mod.add 2, 'key1'
      assert mod.getNext(3) is undefined

    it 'should work with javascript funky sorting', ->
      mod.add 1, 'key1'
      mod.add 5, 'key5'
      mod.add 10, 'key10'
      mod.getNext(1.1).should.eql 'key5'

  describe '#getSmallest', ->
    it 'should get the smallest value', ->
      mod.add 1, 'key1'
      mod.add 0, 'key0'
      mod.getSmallest().should.eql 'key0'

  describe '#getBiggest', ->
    it 'should return the biggest value', ->
      mod.add 1, 'key1'
      mod.add 0, 'key0'
      mod.getLargest().should.eql 'key1'

  describe '#get', ->
    it 'should throw when no predicate is given', ->
      (-> mod.get null).should.throw 'Predicate expected'

    it 'should work with custom predicates', ->
      mod.add 2, 'key2'
      mod.add 0, 'key1'
      res = mod.get (item, index, arr) -> arr[index] >= item and item <= 1
      res.should.eql 'key1'

  describe '#getRight', ->
    it 'should throw when no predicate is given', ->
      (-> mod.getRight null).should.throw 'Predicate expected'

    it 'should work with custom predicates', ->
      mod.add 2, 'key2'
      mod.add 0, 'key1'
      res = mod.getRight (item, index, arr) -> arr[index] <= item and item >= 1
      res.should.eql 'key2'
