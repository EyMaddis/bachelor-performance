url = null
@results = []
maxInstances = 0
@test_instances = []
current_id = 0

window.bla = 0

allConnectionsEstablished = () ->
  console.log 'all connections established, triggering test'
  ResultRenderer.drawResults(results)
  for test in test_instances
    test.triggerSimulation()

allTestsFinished = () ->
  console.log 'Alle Tests abgeschlossen'

finishedTests = 0

class Test
  constructor: (instance) ->
    @instance = instance
    @id = current_id
    current_id += 1
#    console.log 'constructor:', @id, instance
    @startTime = Date.now()
    @established = 0
    @timesBetweenPackages = []
    @packetReceived = []

    # establish connection
    @webSocket = new WebSocketRails url
    @webSocket.on_open = @onOpen
    @webSocket.on_close = @onClose
    @webSocket.on_error = @onError
    @webSocket._conn.on_close = @onClose
    @webSocket._conn.on_error = @onError
    @webSocket._conn.on_open = @onOpen

  getRoundTripTime: () =>
    @established - @startTime

  onOpen: (event) =>
    @established = Date.now()
    rtt = @getRoundTripTime()
    results[@id] = [@id,rtt]

    if @id >= (maxInstances-1)
      allConnectionsEstablished()
    console.log 'established', @id

    @webSocket.bind 'step', @receivePacket

  isFailed: () ->
    return @failed || @failedSubscription

  onClose: (event) =>
    console.log "Verbindung bei Test verloren:", @id
    @closed = true

  onError: (event) =>
    @established = Date.now()
    console.log 'error occurred for id: ', @id, ' error: ', event, ' RTT:', @getRoundTripTime()
    @failed = true


  receivePacket: (packet) =>
    bla++

    @packetReceived.push Date.now()
    @receivedPacket = true
    console.log packet
    for op in packet.operations
      console.log op.name
      continue if op.name != 'exit'
      @done = true
      console.log 'test finished', @id, finishedTests
      finishedTests++
      for msg in packet.messages
        if msg.type is 'error'
          @failed = true
          @error = msg.message
          console.log msg.message

      if finishedTests >= maxInstances
        allTestsFinished()


  triggerSimulation: () =>
    @webSocket.trigger "simulateGrid", @instance
    @triggered = Date.now()
    console.log 'triggered test for', @id
    return @triggered

# Load the page.
$ () ->
  $instances = $('#test_instance')
  for name, obj of Tests
    $instances.append("<option>#{name}</option>")


  $results = $ '#results'

  runTests = (testInstance) ->
    @test_instances = new Array(maxInstances)
    for i in [0...maxInstances]
      test = new Test(testInstance)
      @test_instances[i] = test

  $('#url').val(localStorage.getItem 'url')
  $(window).on 'beforeunload', (event) ->
    localStorage.setItem 'url', $('#url').val()

  $('#runTests').click () ->

    url = $('#url').val()
    finishedTests = 0
    maxInstances = parseInt($('#instances').val())
    window.test_instances = new Array(maxInstances)
    window.results = new Array(maxInstances)
    test = $('#test_instance').val()
    console.log "Starte Tests"
    runTests Tests[test]

  
