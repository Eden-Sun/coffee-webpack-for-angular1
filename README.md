# gulp-coffee-webpack
use gulp and webpack building and all setting are using coffeescript    

## why need gulp ?    

Sometimes(or always) we need to edit the webpack.config file.    
Thus gulp can help us rerun the task, and this is all gulp's work.

global node dependencies : gulp (webpack is needed only when build production)  
```bash
 # install all local dependencies  
  npm install
 # run gulp task default will build once and watch to webpack.config.coffee  
  gulp
```   

## build production
webpack can easily build production mode and minify bundle. To use it ,
```bash
  webpack -p
```
* needs global webpack installed

## web plugins

*As this example is an angular app . A plugin ng-annotate-webpack-plugin is needed when minifying script.*  
Just add to plugins array.

That's it. So easy.
