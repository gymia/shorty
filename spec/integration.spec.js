var request = require('supertest');

// init dependencies
var redis = require('then-redis');
var RedisStore = require('../lib/redis_store');
var URLShortener = require('../lib/url_shortener');
var ShortcodeGenerator = require('../lib/shortcode_generator');

describe('Full App', function() {

  var app;

  before(function(done) {
    redis.connect().then(function(dbClient) {
      var redisStore = new RedisStore(dbClient);
      var generator = new ShortcodeGenerator();
      var shortener = new URLShortener(redisStore, generator);

      // init app
      app = require('../lib/app.js')(shortener);
      done();
    });
  });

  it('returns 404 when shortcode cannot be found', function(done) {
    request(app)
      .get('/nonExisting')
      .expect(404)
      .end(done);
  });

  it('shortens URLs and redirects with 302 afterwards', function(done) {
    var url = 'http://www.example.com';
    request(app)
      .post('/shorten')
      .send({ url: url })
      .expect(201)
      .end(function(err, res) {
        if (err) return done(err);
        var shortcode = res.body.shortcode;
        request(app)
          .get('/' + shortcode)
          .expect(302)
          .expect('Location', url)
          .end(done);
      });
  });

});
