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

    it('returns 400 when url is not provided', function(done) {
      request(app)
        .post('/shorten')
        .send({ urll: 'http://typo.in.parameter.name' })
        .expect(400)
        .end(done);
    });

    describe('with specified shortcode requested', function() {
      var url = 'http://www.example.com';
      var shortcode = 'Sh0rtCd';

      it('returns 409 if shortcode already exists', function(done) {
        shortener.shortenURLWithShortcode = sinon.stub();
        var message = "shortcode already exists";
        shortener.shortenURLWithShortcode.rejects(new Error(message));
        request(app)
          .post('/shorten')
          .send({ url: url, shortcode: shortcode })
          .expect(409)
          .end(done);
      });

      it('returns 422 if shortcode has incorrect format', function(done) {
        shortener.shortenURLWithShortcode = sinon.stub();
        var message = "invalid shortcode format";
        shortener.shortenURLWithShortcode.rejects(new Error(message));
        request(app)
          .post('/shorten')
          .send({ url: url, shortcode: 'abc' })
          .expect(422)
          .end(done);
      });
    });

  });

  describe('GET /:shortcode/stats', function() {

    it('returns 404 when stats cannot be found', function(done) {
      shortener.getStats = sinon.stub();
      shortener.getStats.rejects();
      request(app)
        .get('/existing/stats')
        .expect(404)
        .end(done);
    });

    it('returns 200 and statistics on success', function(done) {
      var stats = {
        'startDate': '2012-04-23T18:25:43.511Z',
        'lastSeenDate': '2012-04-23T18:25:43.511Z',
        'redirectCount': 1
      };
      shortener.getStats = sinon.stub();
      shortener.getStats.withArgs('existing').resolves(stats);
      request(app)
        .get('/existing/stats')
        .expect(200, stats)
        .end(done);
    });

  });

});
