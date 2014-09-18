var ShortcodeGenerator = require('../lib/shortcode_generator');
var _ = require('lodash');
var expect = require('chai').expect;

describe('Shortcode Generator', function() {

  var generator;
  var pattern = /^[a-zA-Z0-9]{6}$/;

  beforeEach(function() {
    generator = new ShortcodeGenerator();
  });

  it('generates shortcodes matching correct pattern', function() {
    _(50).times(function() {
      expect(generator.generate()).to.match(pattern)
    });
  });

  it('generates different shortcodes', function() {
    var one = generator.generate();
    var two = generator.generate();
    expect(one).not.to.equal(two);
  });

});
