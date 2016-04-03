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

  ctx.redirect(url);
};

exports.stats = function *(db, ctx) {
  const code = ctx.params.shortcode;
  const obj = yield store.stats(db, code);

  ctx.body = obj;
};
