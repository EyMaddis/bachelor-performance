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

  @drawPie = (div, results) ->
    biggerFont = (label, series) ->
      return "<div style='font-size:20px; padding: 5px; background: white;color: "+series.color+"'>" + label + "<br/>" +series.percent.toFixed(2) + "% (#{series.data[0][1].toFixed(2)} ms)</div>";
    options = {
      series: {
        pie: {
          show: true
          label: {
            formatter: biggerFont
          }
        }
      }
      legend: {
        show: false
      }
      colors: ["#0B8500", "#0022FF", "#AA0000"]
    }
    $(div).plot(results, options)

  @drawLines = (div, data) ->
    options = {
      legend: {
        show: true
      }
      colors: ["#0B8500", "#0022FF", "#AA0000"]
      series: {
        lines: {
          show: true
        }
      }
    }
    $(div).plot(data, options)