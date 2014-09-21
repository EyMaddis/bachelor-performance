url = 'chevalblanc.informatik.uni-kiel.de:3000/websocket'
window.times = new Array(100)
avg = 0
$counter = $('#counter')
tests = 100

runTest = (id) ->
  webSocket = new WebSocketRails url

  onOpen = () ->
    sent = Date.now()
    webSocket.bind 'pong', () ->
      times[id-1] = Date.now() - sent
      webSocket.disconnect()
      $counter.val(id-1)
    webSocket.trigger 'ping'

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

$ () ->

  $('#runTests').click () ->
    url = $('#url').val()
    runTest(tests)