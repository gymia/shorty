"use strict";

const koa = require("koa");
const bodyParser = require("koa-bodyparser");

module.exports = function () {
  const app = koa();

  app.use(bodyParser());
  return app;
}
