const app = require("../src/app");

const request = require("supertest").agent(app().listen());

describe("Shorty Server", function () {
  it("fails with 404 when :shortcode doesn't exist", function (done) {
    request
      .get("/foobar")
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(404, done);
  });
});
