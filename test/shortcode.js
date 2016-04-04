/*global describe it*/

const _ = require("lodash");
const shortcode = require("../src/shortcode");

const chai = require("chai");
const expect = chai.expect;

chai.use(require("chai-things"));

describe("src/shortcode.js", function () {
  it("generate() should generate valid shortcodes", function () {
    const codes = _.times(200, shortcode.generate);
    expect(codes).to.all.match(/^[0-9a-zA-Z_]{6}$/);
  });

  it("isValid() should accept valid shortcodes", function () {
    expect("ozan").to.satisfy(shortcode.isValid);
    expect("FOOBAR").to.satisfy(shortcode.isValid);
    expect("FooBar_586").to.satisfy(shortcode.isValid);
  });

  it("isValid() should reject invalid shortcodes", function () {
    expect("foobar-").not.to.satisfy(shortcode.isValid);
    expect("foo").not.to.satisfy(shortcode.isValid);
    expect("fóóbar").not.to.satisfy(shortcode.isValid);
  });
});
