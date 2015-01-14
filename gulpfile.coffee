gulp = require('gulp')
coffee = require('gulp-coffee')
gutil = require('gulp-util')
plumber = require('gulp-plumber')
header = require('gulp-header')

errorLog = (err) ->
  console.log(err.code)

gulp.task 'default', ['coffee', 'header']

gulp.task 'coffee', ->
  gulp.src('src/**/*.coffee')
    .pipe(plumber())
    .pipe(coffee(bare: true))
    .pipe(gulp.dest('./'))

gulp.task 'header', ['coffee'], ->
  gulp.src('bin/entry.js')
    .pipe(header("#!/usr/bin/env node\n"))
    .pipe(gulp.dest('./bin/'))

gulp.task 'watch', ->
  gulp.watch 'src/**/*.coffee', ['coffee', 'header']