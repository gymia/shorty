function ShortcodeGenerator() {}

ShortcodeGenerator.prototype = {

  chars: '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',

  length: 6,

  generate: function() {
    var result = '';
    for (var i = 0; i < this.length; i++) {
      result += this.chars[Math.round(Math.random() * (this.chars.length - 1))];
    }
    return result;
  }

};

module.exports = ShortcodeGenerator;
