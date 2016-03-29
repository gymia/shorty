'use strict';
var root = './app/';
var e2eRoot = './e2e/';
var e2eOutput = './.tmp_e2e/';
var gulpConfig = {
    allts: root + '**/*.ts',
    allTypings: './typings/main/**/*.ts',
    outputFolder: './dist/',
    allUnitTests: root + '**/*.spec.ts',
    allE2ETests: e2eRoot + '**/*.e2e.ts',
    compiledE2EPath: e2eOutput,
    compiledE2ETests: e2eOutput + '/**/*.e2e.js'
};

module.exports = gulpConfig;