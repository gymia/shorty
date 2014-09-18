var sinon = require('sinon');
var chai = require('chai');
var expect = chai.expect;

// promises support
var Promise = require('rsvp').Promise;
require('sinon-as-promised')(Promise);
chai.use(require('chai-as-promised'));

var RedisStore = require('../lib/redis_store');

describe('Redis Store', function() {

  var store, client;
  var shortcode = 'Sh0rtcd';
  var url = 'http://example.com'

  beforeEach(function() {
    client = {}
    store = new RedisStore(client);
  });

  describe('#getURL', function() {

    it('returns a promise of URL for given shortcode', function() {
      client.hget = sinon.stub();
      client.hget.withArgs(shortcode, 'url').resolves(url);
      var result = store.getURL(shortcode);
      return expect(result).to.eventually.equal(url);
    });

    it('returns rejected promise on failure', function() {
      client.hget = sinon.stub()
      client.hget.withArgs(shortcode, 'url').rejects();
      var result = store.getURL(shortcode);
      return expect(result).to.be.rejected;
    });

  });

  describe('#addURL', function() {

    it('returns a promise of adding a new mapping', function() {
      client.hset = sinon.stub()
      client.hset.withArgs(shortcode, 'url', url).resolves();
      var result = store.addURL(shortcode, url);
      return expect(result).to.be.fulfilled;
    });

    it('returns rejected promise on failure', function() {
      client.hset = sinon.stub();
      client.hset.rejects();
      var result = store.addURL(shortcode, url);
      return expect(result).to.be.rejected;
    });

  });

  describe('#exists', function() {

    it('resolves to true if given shortcode is persisted', function() {
      client.exists = sinon.stub();
      client.exists.withArgs(shortcode).resolves(true);
      var result = store.exists(shortcode);
      return expect(result).to.eventually.be.true;
    });

    it('resolves to false if given shortcode is not persisted', function() {
      client.exists = sinon.stub();
      client.exists.withArgs(shortcode).resolves(false);
      var result = store.exists(shortcode);
      return expect(result).to.eventually.be.false;
    });

    it('returns rejected promise on failure', function() {
      client.exists = sinon.stub();
      client.exists.rejects();
      var result = store.exists(shortcode);
      return expect(result).to.be.rejected;
    });

  });

});
