import sinon = require('sinon');
import chai = require('chai');
import sinonChai = require('sinon-chai');
import {ShortcodeGenerator} from './generatorService';

chai.use(sinonChai);
let expect = chai.expect;

describe('The shortcode generator', ()=> {
    it('generates a shortcode of the correct length and characters', ()=> {
        let shortcodeGenerator = new ShortcodeGenerator();

        expect(shortcodeGenerator.generate()).to.match(/^[0-9a-zA-Z_]{6}$/);
    });

    it('generates a different shortcode on every call', ()=> {
        let shortcodeGenerator = new ShortcodeGenerator();

        expect(shortcodeGenerator.generate()).not.to.equal(shortcodeGenerator.generate());
    });
});