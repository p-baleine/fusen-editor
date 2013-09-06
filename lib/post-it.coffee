
# Module dependencies.
Bacon = require 'baconjs'

require 'svg.draggable.js'  

class PostIt

  constructor: (@draw) ->
    @render()
    @dragmove = new Bacon.Bus
    @el.dragmove = @dragmove.push

  subscribe: (branch) ->
    branch.of('moving').assign @el, 'transform'
    @

  plugTo: (dest) ->
    dest.plug @dragmove
    @

  render: ->
    @el = @draw.group()
    @el.draggable()    

exports = module.exports = PostIt
