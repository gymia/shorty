var express = require('express');
var bodyParser = require('body-parser');

module.exports = function(shortener) {
  var app = express();

  app.use(bodyParser.json());

  app.get('/:shortcode', function(req, res) {
    var shortcode = req.params['shortcode'];
    shortener.getURLByShortcode(shortcode).then(
      // success
      function(url) {
        res.redirect(302, url);
      },
      // failure
      function() {
        res.status(404).end();
      }
    );
  });

  app.post('/shorten', function(req, res) {
    var url = req.body.url;
    if (!url) {
      return res.status(400).end();
    }

    var requested = req.body.shortcode;
    var promise;
    if (!requested) {
      promise = shortener.shortenURL(url);
    } else {
      promise = shortener.shortenURLWithShortcode(url, requested);
    }

    promise.then(
      // success
      function(shortcode) {
        res.status(201).send({ shortcode: shortcode });
      },
      // failure
      function(err) {
        if (err.message === 'invalid shortcode format') {
          return res.status(422).end()
        }
        if (err.message === 'shortcode already exists') {
          return res.status(409).end();
        }
        res.status(500).end();
      }
    );
  });

  app.get('/:shortcode/stats', function(req, res) {
    var shortcode = req.params['shortcode'];
    shortener.getStats(shortcode).then(
      // success
      function(stats) {
        res.status(200).send(stats);
      },
      // failure
      function() {
        res.status(404).end();
      }
    );
  });

  return app;
};
