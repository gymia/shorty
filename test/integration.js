/*global describe it*/

const app = require("../src/app");

const redis = require("fakeredis");
const redisClient = redis.createClient();

const request = require("supertest").agent(app(redisClient).listen());
const expect = require("chai").expect;

describe("Shorty Server", function () {
  it("fails with 404 when :shortcode doesn't exist", function (done) {
    request
      .get("/foobar")
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(404, done);
  });

  it("fails with 404 when :shortcode/stats doesn't exist", function (done) {
    request
      .get("/foobar/stats")
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(404, done);
  });

  it("fails with 400 when url is not present", function (done) {
    request
      .post("/shorten")
      .send({
        shortcode: "foobar"
      })
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(400, done);
  });

  it("fails with 422 when provided shortcode is not valid", function (done) {
    request
      .post("/shorten")
      .send({
        url: "http://example.com",
        shortcode: "-foobar-"
      })
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(422, done);
  });

  it("generates a valid shortcode when one isn't provided", function (done) {
    request
      .post("/shorten")
      .send({
        url: "http://example.com"
      })
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(201)
      .end(function (err, res) {
        expect(res.body).to.have.property("shortcode")
          .and.match(/^[0-9a-zA-Z_]{6}$/);

        done();
      });
  });

  it("accepts a valid shortcode", function (done) {
    request
      .post("/shorten")
      .send({
        url: "http://example.com",
        shortcode: "foobar"
      })
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(201, {
        shortcode: "foobar"
      }, done);
  });

  it("fails with 409 when the provided shortcode is in use", function (done) {
    request
      .post("/shorten")
      .send({
        url: "http://example.com",
        shortcode: "foobar"
      })
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(409, done);
  });

  it("has correct stats for a fresh shortcode", function (done) {
    request
      .get("/foobar/stats")
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(200)
      .end(function (err, res) {
        expect(res.body).to.have.property("startDate")
          .and.be.a("string")
          .and.satisfy(Date.parse);

        expect(res.body).to.not.have.property("lastSeenDate");

        expect(res.body).to.have.property("redirectCount")
          .and.equal(0);

        done();
      });
  });

  it("302 redirects to the correct URL", function (done) {
    request
      .get("/foobar")
      .expect("Location", "http://example.com")
      .expect(302, done);
  });

  it("has correct stats for a visited shortcode", function (done) {
    request
      .get("/foobar/stats")
      .accept("json")
      .expect("Content-Type", /json/)
      .expect(200)
      .end(function (err, res) {
        expect(res.body).to.have.property("startDate")
          .and.be.a("string")
          .and.satisfy(Date.parse);

        expect(res.body).to.have.property("lastSeenDate")
          .and.be.a("string")
          .and.satisfy(Date.parse);

        expect(res.body).to.have.property("redirectCount")
          .and.equal(1);

        done();
      });
  });
});
