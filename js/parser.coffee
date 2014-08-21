saves = {}

parse = (log) ->
  lines = log.split("\n")
  results = {}
  nextName = ""
  for line in lines
    hashIndex = line.indexOf("#")
    if hashIndex > -1
      nextName = line.substring(hashIndex+1, line.length)
      continue

    if line.length < 1
      continue

    entry = line.split ','
    id = entry[0]
    label = entry[1]
    ms = parseFloat entry[2]

    obj = {}
    obj[id] = {}
    obj[id].label = nextName
    obj[id][label] = ms
    results[id] = {} unless results[id]?
    $.extend true, results, obj
  console.log results
  return results

drawPies = () ->

  log = $('#log').val()
  id = $('#connection_id').val()

  $('#pies').html saves.pie
  for conn, timings of parse log
    receive_code = timings['receive_code']
    communicate_with_vm = timings['communicate_with_vm']
    vm = timings['vm']

    $('#pie-prepender').before("<div style='float:left'><h2>#{timings.label} (#{receive_code.toFixed(2)}ms)</h2><div id='pie-#{conn}' style='width: 500px; height: 400px;'></div></div>")
    #      start_simulation = obj['start_simulation']


    data = [
#        {
#          label: "Preprozessor"
#          data: start_simulation - communicate_with_vm
#        }
      {
        label: "Präprozessor"
        data: receive_code - communicate_with_vm
      }
      {
        label: "API"
        data: communicate_with_vm - vm
      }
      {
        label: "Virtuelle Maschine"
        data: vm
      }
    ]
    ResultRenderer.drawPie "#pie-#{conn}", data

drawCompare = () ->

  log = $('#compareLog').val()
  x = 0

  $('#comparisons').html(saves.comparisons)
  data1 = {label: 'receive_code', data: []}
  data2 = {label: 'communicate_with_vm', data: []}
  data3 = {label: 'vm', data: []}
  for conn, timings of parse log
    receive_code = timings['receive_code']
    communicate_with_vm = timings['communicate_with_vm']
    vm = timings['vm']
    data1.data.push [x, timings['receive_code']]
    data2.data.push [x, timings['communicate_with_vm']]
    data3.data.push [x, timings['vm']]
    x++
  data = [data1,data2, data3]
  $('#comparisons-prepender').before("<div style='float:left'><div id='comp' style='width: 500px; height: 400px;'></div></div>")
  console.log data
  ResultRenderer.drawLines '#comp', data


saveState = (id) ->
  $(id).val(localStorage.getItem id)
  $(window).on 'beforeunload', () ->
    localStorage.setItem id, $(id).val()

$ () ->
  saveState '#log'
  saveState '#connection_id'
  saveState '#compareLog'

  saves.pie = $('#pies').html()
  saves.comparisons = $('#comparisons').html()

  $('#start').click () ->
    drawPies()
#    drawCompare()
