class @ResultRenderer
  @drawResults = (results) ->
    $("#result-flot").plot [results], {
      axisLabels: {
        show: true
      }
      xaxes: [{
        axisLabel: 'connection id',
      }]
      yaxes: [{
        position: 'left',
        axisLabel: 'response time (ms)',
      }]
    }