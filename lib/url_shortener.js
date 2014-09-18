function URLShortener(store) {
  this.store = store;
}

URLShortener.prototype = {

  // Returns URI corresponding to given shortcode, or null if not found
  getURLByShortcode: function(shortcode) {
    return null;
  },

  // Returns a shortcode created for given URI
  shortenURL: function(url) {
    return null; // FIXME stub
  }

};

module.exports = URLShortener;
