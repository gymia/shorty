

var gulp = require('gulp-help')(require('gulp')),
path = require('path'),
fs = require('fs'),
mocha = require('gulp-mocha')


gulp.task('testing', 'run integration tests', function(done) {
	var testDir = ('./testing');
	var testFiles = fs.readdirSync(testDir)
	.filter(function(item) {return !fs.statSync(path.join(testDir, item)).isDirectory()})
	.map(function(item) {return path.join(testDir, item)});

	return gulp.src(testFiles, {read: false})
	.pipe(mocha())
	.once('end', function()  {
		process.exit();
	});
});
