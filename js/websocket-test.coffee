url = null
@results = []
maxInstances = 0
@test_instances = []
current_id = 0


class Test
  constructor: (@instance) ->
    @id = current_id
    current_id += 1
#    console.log 'constructor:', @id, instance
    @startTime = Date.now()
    @established = 0
    @timesBetweenPackages = []

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
      console.log 'Test finished', results
      ResultRenderer.drawResults(results)
    console.log 'established', @id

  triggerSimulation: () =>
    @webSocket.trigger "simulateGrid", @instance
    @triggered = Date.now()

  isFailed: () ->
    @failed || @failedSubscription

  onClose: (event) =>
    console.log "Verbindung bei Test verloren:", @id
    @closed = true

  onError: (event) =>
    @established = Date.now()
    console.log 'error occurred for id: ', @id, ' error: ', event, ' RTT:', @getRoundTripTime()
    @failed = true

  onSubscriptionFail: () =>
    @failedSubscription = true

  onSubscription: () =>
    @channelSubscribed = Date.now()

#  receivePacket: (packet) =>
#    @packetReceived = Date.now()
#    @receivedPacket = true
#    if 'exit' in packet.operations
#      @done = true
#      console.log 'test finished'
#      for msg in packet.messages
#        if msg.type is 'error'
#          @failed = true
#          @error = msg.message
#          console.log msg.message


# Load the page.
$ () ->
  $instances = $('#test_instance')
  for name, obj of Tests
    $instances.append("<option>#{name}</option>")


  $results = $ '#results'

  runTests = (testInstance) ->
    test_instances = new Array(maxInstances)
    for i in [0...maxInstances]
      test = new Test(testInstance)
      test_instances[i] = test

  $('#runTests').click () ->
    url = $('#url').val()
    maxInstances = parseInt($('#instances').val())
    window.results = new Array(maxInstances)
    test = $('#test_instance').val()
    console.log "Starte Tests"
    runTests Tests[test]

  
