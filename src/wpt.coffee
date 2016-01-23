syntaxHighlight = (json) ->
  json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
  json.replace /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) ->
    cls = 'number'
    if /^"/.test(match)
      if /:$/.test(match)
        cls = 'key'
      else
        cls = 'string'
    else if /true|false/.test(match)
      cls = 'boolean'
    else if /null/.test(match)
      cls = 'null'
    '<span class="' + cls + '">' + match + '</span>'
testApis =[
  "dxGetAbout"
  "dxGetNetworkSettings"
  "dxSetNetworkSettings" #2
  "dxGetPower"
  "dxSetPower" #4
  
  "dxGetMapping"
  "dxSetMapping" #6
  
  "dxGetStatus"
  "dxResetDevice"  #8
  "dxUpdateFirmware"
  "dxGetStatusUpdateFrequency" #10
  "dxSetStatusUpdateFrequency"
  "dxGetTimeSettings" #12
  "dxSetTimeSettings"
  "dxSetCloudServerUrl" #14
  

  "dxGetPowerStatus"
  "dxSetPowerCfg"  #16

  "dxGetSchedules"
  "dxSetSchedules"  #18

  "dxGetHwMonitor" #19

  "dxSetHDCP"  #20
  "dxGetHDCP"
  "dxGetHDCPStatus" #22
  "dxGetEDID"
  "dxSetEDID"  #24
  "dxGetEDIDOptions"
  "dxGetMatrixStatus" #26
  "dxGetMaps"
  "dxSetMaps" #28
  
  #mapping set get in 5,6
  "dxGetPortInfo" #29
  "dxSetPortInfo" #30

  "dxDefaultDevice" #31
  "dxRollbackDevice" #32
]
get_appropriate_ws_url = ->
  u = document.URL
  if u.substring(0, 5) == "https"
    pcol = "wss://"
    u = u.substr(8)
  else
    pcol = "ws://"
    if u.substring(0, 4) == "http"
      u = u.substr(7)
  u = u.split('/')
  pcol + u[0]

rpc = new OVRPC( get_appropriate_ws_url())
rpc.subscribe 'dsLogStatusUpdates', (st)->
  return if typeof(st) isnt 'object'
  s = JSON.stringify st,undefined,4
  $("#evmsgs").html syntaxHighlight s
rpc.subscribe 'dsStatusNotifications', (st)->
  return if typeof(st) isnt 'object'
  console.log st
  s = JSON.stringify st,undefined,4
  $("#evmsgs").html syntaxHighlight s
angular = require 'angular'
app=angular.module 'app',[]
app.controller 'mainCon',($scope,$http,$interval)->
  $scope.devices = []
  $interval ->
    $http.get('/ajax/devlist').success (data)->
      # data=["S123","D2312"]
      if $scope.devices.length < data.length and $scope.targetDevice.mac is "none"
        $scope.targetDevice.mac = data[data.length-1]
      $scope.devices = data
  ,500

  $scope.asocode=''
  $scope.doasoc = ->
    $http.post( '/ajax/associate_device', { asocode:@asocode}).success (retobj)->
      if retobj.deviceId?
        $scope.devids.push retobj.deviceId
  $scope.devids  =[]

  $scope.apis = testApis
  $scope.targetDevice=
    mac:"none"
  $scope.callApi = (apinm)->
    console.log apinm
    $("#result").html "wating for result..."
    requestObject ={}
    api = testApis[apinm] 
    if apinm is 2
      nwSetting = $(".nwSetting")
      i = 0
      requestObject.deviceName = $(nwSetting[i++]).val()
      requestObject.deviceIpAddress = $(nwSetting[i++]).val()
      requestObject.deviceSubnetMask = $(nwSetting[i++]).val()
      requestObject.deviceDefaultGateway = $(nwSetting[i++]).val()
      requestObject.dhcpEnabled = $(nwSetting[i++]).val()
      requestObject.dnsServer1 = $(nwSetting[i++]).val()
      requestObject.dnsServer2 = $(nwSetting[i++]).val()
      requestObject.webPagePort = $(nwSetting[i++]).val()
    else if apinm is 4
      requestObject.power = $('input[name=power]:checked').val() 
    else if apinm is 6
      requestObject.mapping = {}
      for p,i in $(".port")
        requestObject.mapping[i+1] = $(p).val()
    else if apinm is 9 
      requestObject.url = $('#url').val()
    else if apinm is 11
      requestObject.frequency = $("#frequency").val()
    else if apinm is 13
      requestObject.timeZone = $('#timeZone').val()
      requestObject.currentTime = $('#currentTime').val()
      requestObject.daylightSavings = $('#daylightSavings').val()
    else if apinm is 14
      requestObject.url = $('#serverUrl').val()
      requestObject.port = $('#port').val()
    rpc.call $scope.targetDevice.mac,testApis[apinm],requestObject,(ret)->
      console.log ret
      $("#result").html syntaxHighlight JSON.stringify(ret or "",undefined,4)
    ,(request)->
      console.log request
      $("#request").html syntaxHighlight JSON.stringify request,undefined,4
  $scope.input=
    locked:true
    enabled:false
  $scope.banks=
    1:
      enabled:false
      locked:false
      sockets:[
        name:"amp"
      ,
        name:"player"
      ,
        name:""
      ]
    2:
      enabled:false
      locked:false
      sockets:[
        name:"oven"
      ,
        name:"air conditioner"
      ]
    3:
      enabled:false
      locked:false
      sockets:[
        name:""
      ,
        name:""
      ]
  $scope.days = ["sun","mon","tue","wed","thu","fri","sat"]
  $scope.dxSetPowerCfg=->
    requestObject={}
    if $scope.input.toSend
      requestObject["inputs"]=[angular.copy $scope.input]
      delete requestObject["inputs"][0].toSend
    requestObject.outlets=angular.copy $scope.banks
    # return console.log requestObject
      # inputs:[$scope.input]
      # outlets:$scope.banks
    for key,bank of requestObject.outlets
      if not bank.toSend
        delete requestObject.outlets[key]
      else
        delete bank.toSend
        for soc in bank.sockets
          delete soc.$$hashKey
    delete requestObject.outlets if Object.keys(requestObject.outlets).length is 0
    console.log requestObject
    rpc.call $scope.targetDevice.mac,testApis[16],requestObject,(ret)->
      console.log ret
      $("#result").html syntaxHighlight JSON.stringify(ret or "",undefined,4)
    ,(request)->
      console.log request
      $("#request").html syntaxHighlight JSON.stringify request,undefined,4
  $scope.schedules =[
    index:1
    enabled:true
    name:"turnon",
    action:"outleton",
    outlets:[{set:null},{set:true},{set:true},{set:true} ]
    time:
      hours:8,
      minutes:0, 
      days:[{set:false},{set:true},{set:true},{set:false},{set:false},{set:false},{set:false}]
  ,
    index:2
    enabled:false
    name:"turnoff",
    action:"outletoff",
    outlets:[{set:null},{set:true},{set:true},{set:true} ]
    time:
      hours:18,
      minutes:30,
      days:[{set:false},{set:true},{set:true},{set:false},{set:false},{set:false},{set:false}]
  ]
  $scope.dxSetSchedules=->
    schedules = angular.copy $scope.schedules
    requestObject=
      schedules:{}
    for sche,scheId in schedules
      delete sche.$$hashKey
      outlets = []
      for ol,index in sche.outlets
        outlets.push index if ol.set
      sche.outlets = outlets
      days=[]
      for day,index in sche.time.days
        days.push $scope.days[index] if day.set
      sche.time.days = days
      key = sche.index or (scheId+1)
      delete sche.index
      requestObject.schedules[key] = sche
      null
    rpc.call $scope.targetDevice.mac,testApis[18],requestObject,(ret)->
      console.log ret.params
      $("#result").html syntaxHighlight JSON.stringify(ret or "",undefined,4)
    ,(request)->
      console.log request
      $("#request").html syntaxHighlight JSON.stringify request, undefined, 4
  $scope.dxSetHDCPData=
    inputs:
      1:
        enabled : true
        engine :"2.2"
      2:
        enabled : true
        engine :"1.4"
      3:
        enabled : false
        engine :"1.4"
      4:
        enabled : true
        engine :"0"
      5:
        enabled : true
        engine :"2.2"
      6:
        enabled : true
        engine :"1.4"
      7:
        enabled : false
        engine :"1.4"
      8:
        enabled : true
        engine :"0"
    outputs:
      1:
        enabled : true
        engine  :"1.4"
      2:
        enabled : true
        engine :"1.4"
      3:
        enabled : true
        engine :"1.4"
      4:
        enabled : true
        engine :"1.4"
      5:
        enabled : true
        engine  :"1.4"
      6:
        enabled : true
        engine :"1.4"
      7:
        enabled : true
        engine :"1.4"
      8:
        enabled : true
        engine :"1.4"
  $scope.dxSetHDCP=->
    requestObject = $scope.dxSetHDCPData
    rpc.call $scope.targetDevice.mac,"dxSetHDCP",requestObject,(ret)->
      console.log ret
      $("#result").html syntaxHighlight JSON.stringify(ret or "",undefined,4)
    ,(request)->
      console.log request
      $("#request").html syntaxHighlight JSON.stringify request,undefined,4 
  randomUDID=->
    s = ""
    crypto = window.crypto || window.msCrypto
    for i in [0...8]
      hex32 = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'.replace /[x]/g, (c)->
          (crypto.getRandomValues(new Uint8Array(1))[0]%16|0).toString(16)
      s+=hex32
    s
  $scope.dxSetEDIDData=
    inputs:
      [
        index:1
        type : "HDMI"
        value :"1"
      # , 
      #   index:3
      #   type : "HDBT"
      #   value :"2"
      # ,
      #   index:5
      #   type : "custom"
      #   value :randomUDID()
      # , 
      #   index:8
      #   type : "default"
      #   value :"4"
      ]
  $scope.dxSetEDID=->
    inputs = angular.copy $scope.dxSetEDIDData.inputs
    requestObject=
      inputs:{}
    for input,index in inputs
      requestObject.inputs[input.index]=input
      console.log requestObject.inputs[input.index]
      if requestObject.inputs[input.index].type isnt "custom"
        requestObject.inputs[input.index].value = Number requestObject.inputs[input.index].value
      delete requestObject.inputs[input.index].index
    rpc.call $scope.targetDevice.mac,"dxSetEDID",requestObject,(ret)->
      console.log ret
      $("#result").html syntaxHighlight JSON.stringify(ret or "",undefined,4)
    ,(request)->
      console.log request
      $("#request").html syntaxHighlight JSON.stringify request,undefined,4 
  $scope.dxSetMapsData=
    maps:
      [
        index:1
        name : "config morning"
        mapping :
          1:"2"
          2:"3"
          3:"3"
          4:"4"
          5:"0"
          6:"0"
          7:"0"
          8:"0"
      # , 
      #   index:3
      #   name : "config night"
      #   mapping :  
      #     1:"2"
      #     2:"3"
      #     3:"3"
      #     4:"4"
      #     5:"0"
      #     6:"0"
      #     7:"0"
      #     8:"0"
      ]
  $scope.dxSetMaps=->
    maps = angular.copy $scope.dxSetMapsData.maps
    requestObject=
      maps:{}
    for map,index in maps
      requestObject.maps[map.index]=map
      delete requestObject.maps[map.index].index
    rpc.call $scope.targetDevice.mac,"dxSetMaps",requestObject,(ret)->
      console.log ret
      $("#result").html syntaxHighlight JSON.stringify(ret or "",undefined,4)
    ,(request)->
      console.log request
      $("#request").html syntaxHighlight JSON.stringify request,undefined,4 
  $scope.mapping=
    1:"2"
    2:"3"
    3:"3"
    4:"4"
    5:"0"
    6:"0"
    7:"0"
    8:"0"
  $scope.dxSetMapping=->
    requestObject=
      mapping:$scope.mapping
    rpc.call $scope.targetDevice.mac,"dxSetMapping",requestObject,(ret)->
      console.log ret
      $("#result").html syntaxHighlight JSON.stringify(ret or "",undefined,4)
    ,(request)->
      console.log request
      $("#request").html syntaxHighlight JSON.stringify request,undefined,4
  $scope.dxSetPortInfoData=
    inputs:
      [
        index:0
        name:"DVD"
      ,
        index:3
        name:"TV"
      ]
    outputs:
      [
        index:7
        name:"24'"
      ,
        index:8
        name:"44'"
      ]
  $scope.dxSetPortInfo=->
    requestObject=
      inputs:{}
      outputs:{}
    for i in [0...2]
      console.log requestObject.inputs[$scope.dxSetPortInfoData.inputs[0].index]
      requestObject.inputs[$scope.dxSetPortInfoData.inputs[i].index]=
        name:$scope.dxSetPortInfoData.inputs[i].name
      requestObject.outputs[$scope.dxSetPortInfoData.outputs[i].index]=
        name:$scope.dxSetPortInfoData.outputs[i].name
    console.log requestObject
    rpc.call $scope.targetDevice.mac,"dxSetPortInfo",requestObject,(ret)->
      console.log ret
      $("#result").html syntaxHighlight JSON.stringify(ret or "",undefined,4)
    ,(request)->
      console.log request
      $("#request").html syntaxHighlight JSON.stringify request,undefined,4
