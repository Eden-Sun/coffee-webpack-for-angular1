require("script!jquery");
angular = require 'angular'
require("./api.css")
uiRouter = require 'angular-ui-router'
c = require "html!./c.jade"
app=angular.module 'app',[uiRouter]
app.config ($stateProvider, $urlRouterProvider, $controllerProvider,$filterProvider, $compileProvider)->
  app.controllerProvider = $controllerProvider
  app.compileProvider = $compileProvider
  app.filterProvider = $filterProvider
  console.log 12445
  $stateProvider
  .state 'main',
    url:'/'
    template : c
    # controller :"webuiCtrl"
    # controller: require "./main"
    # controllerAs : 'main'

  .state 'main.power',
    url:'power'
    templateUrl:'views/power.html'
    controller:'power'
  
  $urlRouterProvider.otherwise "/"

app.controller 'webuiCtrl', ($scope)->
  $scope.some = "initial"
