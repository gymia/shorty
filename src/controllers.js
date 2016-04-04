"use strict";

const shortcode = require("./shortcode");
const store = require("./store");

exports.create = function *(db, ctx) {
  const code = ctx.request.body.shortcode || shortcode.generate();
  const url = ctx.request.body.url;
  yield store.create(db, code, url);

  ctx.status = 201;
  ctx.body = { shortcode: code };
};

exports.find = function *(db, ctx) {
  const code = ctx.params.shortcode;
  const url = yield store.find(db, code);

  ctx.assert(url, 404, "The shortcode cannot be found in the system");

  ctx.redirect(url);
};

exports.stats = function *(db, ctx) {
  const code = ctx.params.shortcode;
  const obj = yield store.stats(db, code);

  ctx.assert(obj, 404, "The shortcode cannot be found in the system");

  ctx.body = obj;
};
