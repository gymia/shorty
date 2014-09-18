var app = require('./app.js');
var port = process.env.PORT || 3000;

var server = app.listen(port, function() {
  console.log('App listening on port %d', server.address().port);
});
