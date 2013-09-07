
# Module dependencies.
Bacon = require 'baconjs'
socket = io.connect '/'
postIt = require './post-it.coffee'

# コマンドの出口
commandUpstream = new Bacon.Bus
commandUpstream.assign socket, 'emit'

# コマンドの入り口
socketStream = Bacon.fromEventTarget.bind Bacon, socket
joined = socketStream('joined').log()
added  = socketStream 'added'
edited = socketStream 'edited'
moving = socketStream 'moving'
moved  = socketStream 'moved'

createPostIt = (data) ->
  # このポストイット要素の支流、dataの変更も担う
  branch = new Branch(data)
    .add('moving', moving)
    .add('moved', moved)
    .add('edited', edited)

  { text, fill, trans } = data

  # ポストイットを生成
  new PostIt(draw, text, fill, trans)
    .subscribe(branch)       # 支流をsubscribe
    .plugTo(commandUpstream) # 本流にplug 

# ポストイット貼り付け
paste = $('#paste').asEventStream('click').map(toCommand)
commands.plug paste

# ポストイットが貼りつけられた
added.onValue createPostIt

# ルームに参加
socket.emit 'join', (room) ->
  room.elements.forEach createPostIt

# TODO このインタフェースの実現
# TODO 他プロジェクトからの利用
# TODO 本家、mount pointのPR
# TODO 「カーソル」
# TODO 「矢印」
