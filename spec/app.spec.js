var common = require('./support/common');
var sinon = common.sinon, expect = common.expect;

var request = require('supertest');

// fake dependencies
var shortener = {};

// prepare app
var app = require('../lib/app.js')(shortener);

describe('App', function() {

  describe('GET /:shortcode', function() {

    it('returns 404 when shortcode cannot be found', function(done) {
      shortener.getURLByShortcode = sinon.stub();
      shortener.getURLByShortcode.rejects();
      request(app)
        .get('/nonExisting')
        .expect(404)
        .end(done);
    });

    it('redirects with 302 when shortcode is resolved', function(done) {
      var url = 'http://www.example.com';
      shortener.getURLByShortcode = sinon.stub();
      shortener.getURLByShortcode.withArgs('existing').resolves(url);
      request(app)
        .get('/existing')
        .expect(302)
        .expect('Location', url)
        .end(done);
    });

  });

  describe('POST /shorten', function() {
    it('returns 201 and the shortcode on success', function(done) {
      var url = 'http://www.example.com';
      var shortcode = 'Sh0rtCd';
      shortener.shortenURL = sinon.stub();
      shortener.shortenURL.withArgs(url).resolves(shortcode);
      request(app)
        .post('/shorten')
        .send({ url: url })
        .expect(201, { shortcode: shortcode })
        .end(done);
    });
  });

});
