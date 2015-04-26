should = require 'should'
_ = require 'lodash'
modash = require '..'

modash(_)


describe 'test modash omitPaths', ->

  it 'should work with a simple nested object', ->

    input = first: second:
      third: fourth: 1
      fifth: sixth: 2
      seventh:
        eighth: 3
        nineth: 4
      tenth: 5

    output = first: second:
      third: {}
      fifth: sixth: 2
      seventh: eighth: 3
      tenth: 5

    should.equal true, _.isEqual output, _.omitPaths input, 'first.second.third.fourth', 'first.second.seventh.nineth'

  it 'should work with a nested object that includes arrays', ->

    input = first: second:
      third: [ { a: 11, b: 12 }, { a: 13, b: 14 } ]
      fifth: sixth: 2
      seventh: [ { eighth: 3 }, { nineth: 4 } ]
      tenth: 5

    output = first: second:
      third: [ { b: 12 }, { b: 14 } ]
      fifth: sixth: 2
      seventh: [ { }, { nineth: 4 } ]
      tenth: 5

    should.equal true, _.isEqual output, _.omitPaths input, 'first.second.third.a', 'first.second.seventh.eighth'


describe 'test modash replacePaths', ->

  it 'should work with a simple nested object', ->

    input = first: second:
      third: fourth: 1
      fifth: sixth: 2
      seventh:
        eighth: 3
        nineth: 4
      tenth: 5

    output = first: second:
      third: fourth: 'whoops!'
      fifth: sixth: 2
      seventh:
        eighth: 3
        nineth: 9
      tenth: 5

    replaced = _.replacePaths input, 'first.second.third.fourth':'whoops!', 'first.second.seventh.nineth':9
    should.equal true, _.isEqual output, replaced

  it 'should work with a nested object that includes arrays', ->

    input = first: second:
      third: [ { a: 11, b: 12 }, { a: 13, b: 14 } ]
      fifth: sixth: 2
      seventh: [ { eighth: 3 }, { nineth: 4 } ]
      tenth: 5

    output = first: second:
      third: [ { a: 66, b: 12 }, { a: 66, b: 14 } ]
      fifth: sixth: 2
      seventh: [ { eighth: 'ohyeah'}, { eighth: 'ohyeah', nineth: 4 } ]
      tenth: 5

    replaced = _.replacePaths input, 'first.second.third.a':66, 'first.second.seventh.eighth':'ohyeah'
    should.equal true, _.isEqual output, replaced

  # TODO: enable this test once the functionality is implemented
  xit 'should traverse array of replacements when replacing an array', ->

    input = first: second:
      third: [ { a: 11, b: 12 }, { a: 13, b: 14 } ]
      fifth: sixth: 2
      seventh: [ { eighth: 3 }, { nineth: 4 } ]
      tenth: 5

    output = first: second:
      third: [ { a: 77, b: 12 }, { a: 88, b: 14 } ]
      fifth: sixth: 2
      seventh: [ { eighth: 'ohyeah'}, { eighth: 'ohyeah', nineth: 4 } ]
      tenth: 5

    replaced = _.replacePaths input, 'first.second.third.a':[77,88], 'first.second.seventh.eighth':'ohyeah'
    should.equal true, _.isEqual output, replaced

