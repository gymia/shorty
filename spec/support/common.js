var chai = require('chai');

exports.sinon = require('sinon');
exports.expect = chai.expect;

// promises support
var Promise = require('rsvp').Promise;
require('sinon-as-promised')(Promise);
chai.use(require('chai-as-promised'));
