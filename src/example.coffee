angular = require 'angular'
app=angular.module 'app',[]
app.controller 'mainCon',($scope,$http,$interval)->
  $scope.devices = []