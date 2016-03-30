// Imports all the modules needed
var express = require('express');
var path = require('path');

var logger = require('morgan');
var bodyParser = require('body-parser');

// Used to connect to the MongoDB database
var mongo = require('mongodb');
var routes = require('./routes/index');

var app = module.exports = express();


app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use(express.static(path.join(__dirname, 'public')));

// Define what route files to use being routes/index.js for /
// routes/users.js for /users
// The route files then render the page
app.use('/', routes);


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500).json({"message" : err.message, "error" : err});    
})
};


// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500).json({"message" : err.message});    
});


var listener = app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", listener.address().port, app.settings.env);
});