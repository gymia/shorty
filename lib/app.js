var express = require('express');

module.exports = function(shortener) {
  var app = express();

  app.get('/:shortcode', function(req, res) {
    var shortcode = req.params['shortcode'];
    // find corresponding URL
    var url = shortener.getURLByShortcode(shortcode);
    // return 404 if not found
    if (url == null) {
      return res.status(404).end();
    }
    // redirect otherwise
    res.redirect(302, url);
  });

  return app;
};
