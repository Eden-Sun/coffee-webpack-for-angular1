# webpack example for angular 1.x
scripts and all setting are using coffeescript    

## why need gulp ?    

Sometimes(or always) we need to edit the webpack.config file.    
Thus gulp can help us rerun the task, and this is all gulp's work.

global node dependencies : gulp (webpack is needed only when build production)  
```bash
 # install all local dependencies  
   npm install
 # run webpack-dev-server by npm script
   npm run watch
```   

## build production
webpack can easily build production mode and minify bundle. To use it ,
```bash
   webpack -p
```
or via npm script
```bash
   npm run build
```

## web plugins

*As this example is an angular app . A plugin ng-annotate-webpack-plugin is needed when minifying script.*  
Just add to plugins array.

That's it. So easy.
