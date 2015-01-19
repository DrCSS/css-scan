gulp = require('gulp')
gutil = require('gulp-util')
plumber = require('gulp-plumber')
webpack = require('gulp-webpack')

require('coffee-script/register')

errorLog = (err) ->
  console.log(err.code)

gulp.task 'default', ['webpack']

gulp.task 'webpack', ->
  gulp.src('src/**/*.coffee')
    .pipe(plumber())
    .pipe(webpack(require('./webpack.config')))
    .pipe(gulp.dest('./dist/'))

gulp.task 'watch', ->
  gulp.watch 'src/**/*.coffee', ['webpack']