
# Module dependencies.
expect = require 'expect.js'
sinon = require 'sinon'
Bacon = require 'baconjs'
$ = require 'jQuery'
SVG = require 'svg.js'
EventEmitter = require('events').EventEmitter
PostIt = require('../lib/post-it.coffee')

describe 'postIt', ->

  beforeEach ->
    @canvas = $('<div/>', id: 'canvas').appendTo('body')
    @draw = SVG 'canvas'

  afterEach ->
    @canvas.remove()

  describe '#constructor()', ->

    describe '描画', ->

      it '@elに`g`要素を割り当てること', ->
        postIt = new PostIt @draw
        console.log postIt.el
        expect(postIt.el.type).to.equal('g')

  describe '#subscribe()', ->

    describe '`moving`', ->

      beforeEach ->
        @emitter = new EventEmitter
        @stream = Bacon.fromEventTarget(@emitter, 'moving')
        @branch = of: ->
        @mock = sinon.mock @branch
        @mock.expects('of').withArgs('moving').returns(@stream)

      it 'ストリームを選択してること', ->
        postIt = new PostIt @draw
        postIt.subscribe @branch
        @mock.verify()

      it '@を返却すること', ->
        postIt = new PostIt @draw
        expect(postIt.subscribe @branch).to.be(postIt)

      describe 'assign', ->

        beforeEach ->
          @assignSpy = sinon.spy @stream, 'assign'

        afterEach ->
          @stream.assign.restore()

        it 'ストリームにassignしてること', ->
          postIt = new PostIt @draw
          postIt.subscribe @branch
          expect(@assignSpy.called).to.be.ok()

      describe 'イベントが発生した時', ->

        it '@elのtranslate属性に値を割り当てること', ->
          postIt = new PostIt @draw
          postIt.subscribe @branch
          @emitter.emit 'moving', x: 99, y: 199

          expect(postIt.el.transform()).to.have.property 'x', 99
          expect(postIt.el.transform()).to.have.property 'y', 199

    describe '`moved', ->

      it 'ストリームにassignしてること'

    describe '`edited', ->
  
      it 'ストリームにassignしてること'

  describe '#plugTo()', ->

    it '@elの`dragmove`イベントをplugしてること', ->
      postIt = new PostIt @draw
      bus = new Bacon.Bus
      spy = sinon.spy()
      bus.onValue spy

      postIt.plugTo bus
      postIt.el.dragmove()

      expect(spy.called).to.be.ok()

    it '@elの`dragend`イベントをplugしてること'

    it '内容の編集終了イベントをplugしてること'

    it '@を返却すること', ->
      postIt = new PostIt @draw
      bus = new Bacon.Bus
      expect(postIt.plugTo(bus)).to.be(postIt)
