
# Module dependencies.
expect = require 'expect.js'
sinon = require 'sinon'
Bacon = require 'baconjs'
SVG = require 'svg.js'
EventEmitter = require('events').EventEmitter
Branch = require '../lib/branch.coffee'

describe 'branch', ->

  describe '#constructor()', ->

    it 'dataにidがない場合、エラーを投げること', ->
      expect(-> new Branch(text: 'hoho')).to.throwError()

  describe '#add()', ->

    it 'key、EventStreamを引数に取ること', ->
      new Branch(id: 1).add('event', new Bacon.EventStream(->))

  describe '#of()', ->

    it '`#add()`で追加したEventStreamを返却すること', ->
      # TODO 異なるkeyのテスト
      branch = new Branch(id: 1).add('myevent', new Bacon.EventStream(->))
      expect(branch.of('myevent')).to.be.a(Bacon.EventStream)

  describe 'イベントの伝播', ->

    beforeEach ->
      @event = new EventEmitter
      @branch = new Branch(id: 'myid')
      @spy = sinon.spy()
      @branch.add('myevent', Bacon.fromEventTarget(@event, 'myevent'))
      @branch.of('myevent').onValue(@spy)

    describe 'イベントのデータのidがdata.idに等しい場合', ->

      it 'イベントを伝播すること', ->
        @event.emit 'myevent', id: 'myid'
        expect(@spy.called).to.be.ok()

    describe 'イベントのデータのidがdata.idに等しくない場合', ->

      it 'イベントを伝播しないこと', ->
        @event.emit 'myevent', id: 'notmyid'
        expect(@spy.called).to.not.be.ok()

# TODO データへのアサイン
