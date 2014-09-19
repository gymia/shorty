var common = require('./support/common');
var sinon = common.sinon, expect = common.expect;

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

    it('returns rejected promise when URL is not found', function() {
      client.hget = sinon.stub();
      client.hget.withArgs(shortcode, 'url').resolves(null);
      var result = store.getURL(shortcode);
      return expect(result).to.be.rejected;
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
      client.hmset = sinon.stub()
      client.hmset.resolves();
      var result = store.addURL(shortcode, url);
      return expect(result).to.be.fulfilled;
    });

    it('returns rejected promise on failure', function() {
      client.hmset = sinon.stub();
      client.hmset.rejects();
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

  describe('#getStats', function() {

    it('returns a promise of stats', function() {
      var hash = {
        url: 'http://example.com',
        startDate: Date.now(),
        lastSeenDate: Date.now(),
        redirectCount: 1
      };
      client.hgetall = sinon.stub();
      client.hgetall.withArgs(shortcode).resolves(hash);
      var result = store.getStats(shortcode);
      return expect(result).to.eventually.deep.equal({
        startDate: hash.startDate,
        lastSeenDate: hash.lastSeenDate,
        redirectCount: hash.redirectCount
      });
    });

    it('returns rejected promise when no such shortcode', function() {
      client.hgetall = sinon.stub();
      client.hgetall.withArgs(shortcode).resolves(null);
      var result = store.getStats(shortcode);
      return expect(result).to.be.rejected;
    });

  });

});
