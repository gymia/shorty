"use strict";

const shortcode = require("./shortcode");
const store = require("./store");

exports.create = function *(db, ctx) {
  const code = ctx.request.body.shortcode || shortcode.generate();
  let url = ctx.request.body.url;

  ctx.assert(url, 400, "url is not present");

  ctx.assert(
    shortcode.isValid(code),
    422,
    "The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$."
  );

  if (!(url.startsWith("http://") || url.startsWith("https://"))) {
    url = "http://" + url;
  }

  yield store.create(db, code, url);

  ctx.status = 201;
  ctx.body = { shortcode: code };
};

exports.find = function *(db, ctx) {
  const code = ctx.params.shortcode;
  const url = yield store.find(db, code);

  ctx.assert(url, 404, "The shortcode cannot be found in the system");

  ctx.redirect(url);
  ctx.body = "";
};

exports.stats = function *(db, ctx) {
  const code = ctx.params.shortcode;
  const obj = yield store.stats(db, code);

  ctx.assert(obj, 404, "The shortcode cannot be found in the system");

  ctx.body = {
    startDate: obj.startDate,
    lastSeenDate: obj.lastSeenDate,
    redirectCount: parseInt(obj.redirectCount, 10)
  };
};
