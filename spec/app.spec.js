var request = require('supertest');
var http = require('http');

// fake dependencies
var shortener = {};

// prepare app
var app = require('../lib/app.js')(shortener);

describe('App', function() {

  describe('GET /:shortcode', function() {

    it('returns 404 when shortcode cannot be found', function(done) {
      shortener.getURLByShortcode = function() { return null; };
      request(app)
        .get('/nonExisting')
        .expect(404)
        .end(done);
    });

    it('redirects with 302 when shortcode is resolved', function(done) {
      var url = 'http://www.example.com';
      shortener.getURLByShortcode = function() { return url; };
      request(app)
        .get('/existing')
        .expect(302)
        .expect('Location', url)
        .end(done);
    });

  });
});
