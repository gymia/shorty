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

    it('returns a promise of URL', function() {
      store.getURL = sinon.stub();
      store.getURL.withArgs(shortcode).resolves(url);
      var result = shortener.getURLByShortcode(shortcode);
      return expect(result).to.eventually.equal(url);
    });

    it('rejects if shortcode not found', function() {
      store.getURL = sinon.stub();
      store.getURL.withArgs(shortcode).rejects();
      var result = shortener.getURLByShortcode(shortcode);
      return expect(result).to.be.rejected;
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

});
