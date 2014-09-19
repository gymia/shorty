var RSVP = require('rsvp');

function RedisStore(client) {
  this.client = client;
}

RedisStore.prototype = {

  // Returns a promise of URL corresponding to given shortcode
  getURL: function(shortcode) {
    return this.client.hget(shortcode, 'url')
      .then(function(url) {
        if (url == null) throw new Error('Not found');
        return url;
      });
  },

  logRedirect: function(shortcode) {
    this.client.hincrby(shortcode, 'redirectCount', 1);
    this.client.hset(shortcode, 'lastSeenDate', new Date().toISOString());
  },

  // Returns a promise of adding a new shortcode -> URL mapping
  addURL: function(shortcode, url) {
    return this.client.hmset(shortcode, {
      'startDate': new Date().toISOString(),
      'redirectCount': 0,
      'url': url
    });
  },

  // Returns a promise of whether such shortcode already exists or not
  exists: function(shortcode) {
    return this.client.exists(shortcode);
  },

  getStats: function(shortcode) {
    return this.client.hgetall(shortcode).then(function(data) {
      if (data == null) throw new Error('Not found');
      return {
        startDate:     data.startDate,
        lastSeenDate:  data.lastSeenDate,
        redirectCount: Number(data.redirectCount)
      };
    });
  }

};

module.exports = RedisStore;
