"use strict";

// Attempt to create a new shortcode pointing to given `url`.
// Returns false if `code` is already in use.
exports.create = function *(db, code, url) {
  const result = yield db.hsetnx(code, "url", url);
  const created = result === 1;

  return created;
};

// Get URL for given `code` if it exists, or null.
exports.find = function *(db, code) {
  const url = yield db.hget(code, "url");

  return url;
};

// Get stats object for given `code` if it exists, or null.
exports.stats = function *(db, code) {
  const stats = yield db.hgetall(code);

  return stats;
};
