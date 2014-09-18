var express = require('express');
var bodyParser = require('body-parser');

module.exports = function(shortener) {
  var app = express();

  app.use(bodyParser.json());

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

  app.post('/shorten', function(req, res) {
    var url = req.body.url;
    var shortcode = shortener.shortenURL(url);
    res.status(201).send({ shortcode: shortcode });
  });

  return app;
};
