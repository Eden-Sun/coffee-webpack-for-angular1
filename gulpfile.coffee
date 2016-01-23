gulp = require "gulp"
gutil = require "gutil"
webpack = require "webpack"
{exec} = require "child_process"
gulp.task 'build', (done)-> 
  config = null
  try
    delete require.cache[require.resolve './webpack.config']
    config = require './webpack.config'
  catch ex
    gutil.log("[webpack.config]", ex.toString())
    exec('say web pack confi error')
  if config
    webpack config , (err, stats)-> 
      gutil.log("[webpack]", stats.toString(colors:true))
      if stats.compilation.errors.length
        exec('say fail')
      else
        exec('say webpack')
  done()

gulp.task 'watch', ['build'],()-> 
  gulp.watch( './webpack.config.coffee' , ['build']).on('change', gutil.log)


gulp.task('default', ['watch'])
