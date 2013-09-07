
# Module dependencies.
Bacon = require 'baconjs'

class Branch

  constructor: (data) ->
    { @id, @text, @fill, @trans } = data
    throw Error 'Invalid argument' unless @id?
    @dict = {}

  add: (key, eventStream) ->
    @dict[key] = eventStream.filter @isMine
    @

  of: (key) ->
    @dict[key]

  isMine: (data) =>
    @id is data.id

exports = module.exports = Branch

