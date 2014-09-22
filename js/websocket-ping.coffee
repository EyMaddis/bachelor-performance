url = 'chevalblanc.informatik.uni-kiel.de:3000/websocket'
avg = 0
$counter = $('#counter')
tests = 100
window.times = new Array(tests)

runTest = (id) ->
  console.log 'starting test', id
  webSocket = new WebSocketRails url
  webSocket.bind 'step', (obj) ->
#    console.log obj
    return unless obj.operations?
    for op in obj.operations
      continue if op.name != 'exit'
      times[id-1] = Date.now() #- sent
      webSocket.trigger 'report' if id <= 1
      webSocket.disconnect()
      $counter.val(id-1)
  onOpen = () ->
#    sent = Date.now()
    console.log 'open!'
    webSocket.trigger 'simulateGrid', Tests.better_search_empty

  onClose = () ->
    console.log id, 'closed, starting next'
    if id <= 1
      sum = 0
      output = ''
      for time in times
        sum += time
        output += "#{time}\n"
      avg = sum/times.length
      output += "\navg: #{avg}"
      console.log 'done!'
      $('#result').val output
    else
      runTest(id-1)

  onError = (err) ->
    console.log "FEHLER! Id:", id, err

  webSocket.on_open = onOpen
  webSocket.on_close = onClose
  webSocket.on_error = onError
  webSocket._conn.on_close = onClose
  webSocket._conn.on_error = onError
  webSocket._conn.on_open = onOpen
#  console.log webSocket
$ () ->

  $('#runTests').click () ->
    console.log 'start!'
    url = $('#url').val()
    runTest(tests)