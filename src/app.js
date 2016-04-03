"use strict";

const koa = require("koa");
const bodyParser = require("koa-bodyparser");
const koaRouter = require("koa-router");

function createRouter() {
  const router = koaRouter();

  router.post("/shorten", function *() {
    this.body = {};
  });

  router.get("/:shortcode", function *() {
    this.body = {};
  });

  router.get("/:shortcode/stats", function *() {
    this.body = {};
  });

  return router;
}

module.exports = function () {
  const app = koa();

  app.use(bodyParser());

  const router = createRouter();
  app.use(router.routes());
  app.use(router.allowedMethods());

  return app;
};
