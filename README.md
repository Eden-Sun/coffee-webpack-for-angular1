# gulp-coffee-webpack
use gulp and webpack building and all setting are using coffeescript    

## why do we need gulp ?    

Sometimes(or always) we need to edit the webpack.config file.    
Thus gulp can help us rerun the task, and this is all gulp's work.

global node dependencies : gulp (webpack is needed only when build production)
1. install all local dependencies
```
npm install 
```
1. run gulp task default will build once and watch to webpack.config.coffee
```
gulp
```
That's it. So easy.
