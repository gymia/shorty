// init dependencies
var redis = require('then-redis');
var RedisStore = require('./redis_store');
var URLShortener = require('./url_shortener');
var ShortcodeGenerator = require('./shortcode_generator');

redis.connect().then(function(dbClient) {
  var redisStore = new RedisStore(dbClient);
  var generator = new ShortcodeGenerator();
  var shortener = new URLShortener(redisStore, generator);

  // init app
  var app = require('./app.js')(shortener);

  var port = process.env.PORT || 3000;

  var server = app.listen(port, function() {
    console.log('App listening on port %d', server.address().port);
  });
});
