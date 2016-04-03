const sampleSize = require("lodash/sampleSize");

const chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

exports.generate = function () {
  return sampleSize(chars, 6).join("");
};

exports.isValid = function (code) {
  return /^[0-9a-zA-Z_]{4,}$/.test(code);
};
