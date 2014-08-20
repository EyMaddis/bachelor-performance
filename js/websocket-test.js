// Generated by CoffeeScript 1.7.1
(function() {
  var Test, current_id, maxInstances, url,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  url = null;

  this.results = [];

  maxInstances = 0;

  this.test_instances = [];

  current_id = 0;

  Test = (function() {
    function Test(instance) {
      this.instance = instance;
      this.onSubscription = __bind(this.onSubscription, this);
      this.onSubscriptionFail = __bind(this.onSubscriptionFail, this);
      this.onError = __bind(this.onError, this);
      this.onClose = __bind(this.onClose, this);
      this.triggerSimulation = __bind(this.triggerSimulation, this);
      this.onOpen = __bind(this.onOpen, this);
      this.getRoundTripTime = __bind(this.getRoundTripTime, this);
      this.id = current_id;
      current_id += 1;
      this.startTime = Date.now();
      this.established = 0;
      this.timesBetweenPackages = [];
      this.webSocket = new WebSocketRails(url);
      this.webSocket.on_open = this.onOpen;
      this.webSocket.on_close = this.onClose;
      this.webSocket.on_error = this.onError;
      this.webSocket._conn.on_close = this.onClose;
      this.webSocket._conn.on_error = this.onError;
      this.webSocket._conn.on_open = this.onOpen;
    }

    Test.prototype.getRoundTripTime = function() {
      return this.established - this.startTime;
    };

    Test.prototype.onOpen = function(event) {
      var rtt;
      this.established = Date.now();
      rtt = this.getRoundTripTime();
      results[this.id] = [this.id, rtt];
      if (this.id >= (maxInstances - 1)) {
        console.log('Test finished', results);
        ResultRenderer.drawResults(results);
      }
      return console.log('established', this.id);
    };

    Test.prototype.triggerSimulation = function() {
      this.webSocket.trigger("simulateGrid", this.instance);
      return this.triggered = Date.now();
    };

    Test.prototype.isFailed = function() {
      return this.failed || this.failedSubscription;
    };

    Test.prototype.onClose = function(event) {
      console.log("Verbindung bei Test verloren:", this.id);
      return this.closed = true;
    };

    Test.prototype.onError = function(event) {
      this.established = Date.now();
      console.log('error occurred for id: ', this.id, ' error: ', event, ' RTT:', this.getRoundTripTime());
      return this.failed = true;
    };

    Test.prototype.onSubscriptionFail = function() {
      return this.failedSubscription = true;
    };

    Test.prototype.onSubscription = function() {
      return this.channelSubscribed = Date.now();
    };

    return Test;

  })();

  $(function() {
    var $instances, $results, name, obj, runTests;
    $instances = $('#test_instance');
    for (name in Tests) {
      obj = Tests[name];
      $instances.append("<option>" + name + "</option>");
    }
    $results = $('#results');
    runTests = function(testInstance) {
      var i, test, test_instances, _i, _results;
      test_instances = new Array(maxInstances);
      _results = [];
      for (i = _i = 0; 0 <= maxInstances ? _i < maxInstances : _i > maxInstances; i = 0 <= maxInstances ? ++_i : --_i) {
        test = new Test(testInstance);
        _results.push(test_instances[i] = test);
      }
      return _results;
    };
    return $('#runTests').click(function() {
      var test;
      url = $('#url').val();
      maxInstances = parseInt($('#instances').val());
      window.results = new Array(maxInstances);
      test = $('#test_instance').val();
      console.log("Starte Tests");
      return runTests(Tests[test]);
    });
  });

}).call(this);

//# sourceMappingURL=websocket-test.map
