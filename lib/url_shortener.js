var Promise = require('rsvp').Promise;

function URLShortener(store, generator) {
  this.store = store;
  this.generator = generator;
}

URLShortener.prototype = {

  // Returns a promise of URI corresponding to given shortcode,
  // rejects if not found
  getURLByShortcode: function(shortcode) {
    var urlPromise = this.store.getURL(shortcode);
    // log redirect
    var store = this.store;
    urlPromise.then(function() {
      store.logRedirect(shortcode);
    });
    return urlPromise;
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

  shortenURLWithShortcode: function(url, shortcode) {
    if (!this._validateShortcode(shortcode)) {
      return new Promise(function(resolve, reject) {
        throw new Error('invalid shortcode format');
      });
    }
    var shortener = this;
    return this.store.exists(shortcode).then(function(exists) {
      if (exists) throw new Error('shortcode already exists');
      return shortener.store.addURL(shortcode, url).then(function() {
        return shortcode;
      });
    });
  },

  getStats: function(shortcode) {
    return this.store.getStats(shortcode);
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
  },

  _validateShortcode: function(shortcode) {
    return shortcode.match(/^[A-Za-z0-9]{4,}$/);
  }
};

module.exports = URLShortener;
