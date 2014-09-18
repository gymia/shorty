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

  // Returns a promise of adding a new shortcode -> URL mapping
  addURL: function(shortcode, url) {
    return this.client.hset(shortcode, 'url', url);
  },

  // Returns a promise of whether such shortcode already exists or not
  exists: function(shortcode) {
    return this.client.exists(shortcode);
  }

};

module.exports = RedisStore;
