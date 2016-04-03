"use strict";

const koa = require("koa");
const bodyParser = require("koa-bodyparser");
const koaRouter = require("koa-router");

const redisWrapper = require("co-redis");

const controllers = require("./controllers");

function createRouter(db) {
  const router = koaRouter();

  router.post("/shorten", function *() {
    yield controllers.create(db, this);
  });

  router.get("/:shortcode", function *() {
    yield controllers.find(db, this);
  });

  router.get("/:shortcode/stats", function *() {
    yield controllers.stats(db, this);
  });

  return router;
}

module.exports = function (redisClient) {
  const app = koa();
  const db = redisWrapper(redisClient);

  app.use(function *(next) {
    try {
      yield next;
    } catch (err) {
      this.status = err.status || 500;
      this.body = { message: err.message };
    }
  });

  app.use(bodyParser());

  const router = createRouter(db);
  app.use(router.routes());
  app.use(router.allowedMethods());

  return app;
};
