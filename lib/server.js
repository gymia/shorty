// init dependencies
var URLShortener = require('./url_shortener');
var shortener = new URLShortener();

// init app
var app = require('./app.js')(shortener);

var port = process.env.PORT || 3000;

var server = app.listen(port, function() {
  console.log('App listening on port %d', server.address().port);
});
