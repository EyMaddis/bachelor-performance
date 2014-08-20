saveState = (id) ->
  $(id).val(localStorage.getItem id)
  $(window).on 'beforeunload', () ->
    localStorage.setItem id, $(id).val()

$ () ->
  saveState '#log'
  saveState '#connection_id'

  $('#start').click () ->
    log = $('#log').val()
    id = $('#connection_id').val()

    $('#pies').html('')

    lines = log.split("\n")
    results = []
    nextName = ""
    for line in lines
      continue if line.length < 1
      hashIndex = line.indexOf("#")
      if hashIndex > -1
        nextName = line.substring(hashIndex+1, line.length)
        continue

      entry = line.split ','
      console.log entry
      results[entry[0]] = {name: nextName} unless results[entry[0]]?
      results[entry[0]][entry[1]] = parseFloat(entry[2]) # id.vm = 83ms

    for conn, obj of results
      receive_code = obj['receive_code']
      communicate_with_vm = obj['communicate_with_vm']
      vm = obj['vm']

      $('#pies').append("<h2>#{obj.name} (#{receive_code.toFixed(2)}ms)</h2><div id='pie-#{conn}' style='width: 500px; height: 400px;'></div>")
#      start_simulation = obj['start_simulation']


      data = [
#        {
#          label: "Preprozessor"
#          data: start_simulation - communicate_with_vm
#        }
        {
          label: "Preprozessor"
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
      console.log data
      ResultRenderer.drawPie "#pie-#{conn}", data
