var common = require('./support/common');
var sinon = common.sinon, expect = common.expect;

var URLShortener = require('../lib/url_shortener');

describe('URL Shortener', function() {

  var shortener, store, generator;
  var shortcode = 'Sh0rtcd';
  var url = 'http://example.com'

  beforeEach(function() {
    store = {};
    generator = {};
    shortener = new URLShortener(store, generator);
  });

  describe('#getURLByShortcode', function() {

    beforeEach(function() {
      store.getURL = sinon.stub();
      store.logRedirect = sinon.stub();
    });

    it('returns a promise of URL', function() {
      store.getURL.withArgs(shortcode).resolves(url);
      var result = shortener.getURLByShortcode(shortcode);
      return expect(result).to.eventually.equal(url);
    });

    it('rejects if shortcode not found', function() {
      store.getURL.withArgs(shortcode).rejects();
      var result = shortener.getURLByShortcode(shortcode);
      return expect(result).to.be.rejected;
    });

    it('logs redirect on success', function(done) {
      store.getURL.withArgs(shortcode).resolves(url);
      store.logRedirect = function(arg) {
        expect(arg).to.equal(shortcode);
        done();
      };
      shortener.getURLByShortcode(shortcode);
    });

  });

  describe('#shortenURL', function() {

    it('returns a promise of shortcode', function() {
      generator.generate = sinon.stub();
      generator.generate.returns(shortcode);
      store.addURL = sinon.stub();
      store.addURL.withArgs(shortcode, url).resolves();
      store.exists = sinon.stub();
      store.exists.withArgs(shortcode).resolves(false);
      var result = shortener.shortenURL(url);
      return expect(result).to.eventually.equal(shortcode);
    });

  });

  describe('#shortenURLWithShortcode', function() {

    it('rejects with "invalid shortcode format"', function() {
      var shortcode = 'a';
      store.addURL = sinon.stub();
      store.addURL.withArgs(shortcode, url).resolves();
      store.exists = sinon.stub();
      store.exists.withArgs(shortcode).resolves(false);
      var result = shortener.shortenURLWithShortcode(url, shortcode);
      var expected = 'invalid shortcode format';
      return expect(result).to.be.rejectedWith(Error, expected);
    });

    it('rejects with "shortcode already exists"', function() {
      store.addURL = sinon.stub();
      store.addURL.withArgs(shortcode, url).resolves();
      store.exists = sinon.stub();
      store.exists.withArgs(shortcode).resolves(true);
      var result = shortener.shortenURLWithShortcode(url, shortcode);
      var expected = 'shortcode already exists';
      return expect(result).to.be.rejectedWith(Error, expected);
    });

    it('returns a promise of shortcode', function() {
      store.addURL = sinon.stub();
      store.addURL.withArgs(shortcode, url).resolves();
      store.exists = sinon.stub();
      store.exists.withArgs(shortcode).resolves(false);
      var result = shortener.shortenURLWithShortcode(url, shortcode);
      return expect(result).to.eventually.equal(shortcode);
    });

  });

  describe('#getStats', function() {

    it('returns a promise of shortcode stats', function() {
      var stats = { 'some': 'stats' };
      store.getStats = sinon.stub();
      store.getStats.withArgs(shortcode).resolves(stats);
      var result = shortener.getStats(shortcode);
      return expect(result).to.eventually.equal(stats);
    });

    it('rejects if stats not found', function() {
      store.getStats = sinon.stub();
      store.getStats.withArgs(shortcode).rejects();
      var result = shortener.getStats(shortcode);
      return expect(result).to.be.rejected;
    });
  });

});
