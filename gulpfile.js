"use strict";
var gulp = require('gulp');
var tsc = require('gulp-typescript');
var sourceMaps = require('gulp-sourcemaps');
var tsProject = tsc.createProject('tsconfig.json');
var tsProjectE2E = tsc.createProject('tsconfig.e2e.json');
var config = require('./gulpConfig');
var exec = require('child_process').exec;
var mocha = require('gulp-spawn-mocha');
var clean = require('gulp-clean');

const CI = process.env.CI === 'true';

var compileTs = function (sourceTsFiles, srcOptions, destination, tsProject) {
    var sourceTsFiles = sourceTsFiles || [];

    var tsResult = gulp.src(sourceTsFiles, srcOptions)
        .pipe(sourceMaps.init())
        .pipe(tsc(tsProject));

    tsResult.dts.pipe(gulp.dest(destination));

    return tsResult.js
        .pipe(sourceMaps.write('.'))
        .pipe(gulp.dest(destination));
};

gulp.task('e2e', ['compile-e2e'], function(cb){
    exec('node ' + config.outputFolder + '/index.js', function(stdout, stderr, err){
        console.log(stdout);
        console.log(stderr);
        cb(err);
    });

    return gulp.src(config.compiledE2ETests, {read: false})
        .pipe(mocha({reporter: CI ? 'dot' : 'spec'}));
});

gulp.task('compile-e2e', function(){
    return compileTs([config.allE2ETests, config.allTypings], {base: './e2e'}, config.compiledE2EPath, tsProjectE2E);
});

gulp.task('compile-all', ['clean'], function () {
    return compileTs([config.allts,
        config.allTypings], undefined, config.outputFolder, tsProject);
});

gulp.task('compile-test', ['compile-all'], function () {
    return compileTs([config.allUnitTests, config.allTypings], undefined, config.outputFolder, tsProject);
});

gulp.task('clean', function(){
    return gulp.src([config.outputFolder, config.compiledE2EPath], {read: false})
        .pipe(clean());
});