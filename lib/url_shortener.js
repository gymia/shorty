function URLShortener(store, generator) {
  this.store = store;
  this.generator = generator;
}

URLShortener.prototype = {

  // Returns a promise of URI corresponding to given shortcode,
  // rejects if not found
  getURLByShortcode: function(shortcode) {
    return this.store.getURL(shortcode);
  },

  // Returns a promise of shortcode created for given URI
  shortenURL: function(url) {
    var shortener = this;
    return this._generateUniqueShortcode().then(function(shortcode) {
        return shortener.store.addURL(shortcode, url).then(function() {
            return shortcode;
          });
      });
  },

  _generateUniqueShortcode: function() {
    var shortcode = this.generator.generate();
    var shortener = this;
    return this.store.exists(shortcode).then(function(exists) {
      if (exists) {
        // the call stack and promise chain could theoretically grow
        // huge, but collisions should be pretty rare
        return shortener._generateUniqueShortcode();
      } else {
        return shortcode;
      }
    });
  }
};

module.exports = URLShortener;
