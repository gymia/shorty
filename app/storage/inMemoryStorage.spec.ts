import {InMemoryStorage} from './inMemoryStorage';
import sinon = require('sinon');
import chai = require('chai');
import sinonChai = require('sinon-chai');
import {ShortcodeStats} from "../models/shortcodeStats";
chai.use(sinonChai);
let expect = chai.expect;

describe('The InMemoryStorage', ()=> {
    let inMemoryShortcodeStorage: InMemoryStorage;
    beforeEach(()=>{
        inMemoryShortcodeStorage = new InMemoryStorage();
    });

    it('stores a shortcode', (done)=> {
        const shortcode = 'aaBBcc';
        const url = 'http://this-is-a-test.nl';

        inMemoryShortcodeStorage.addUrl(shortcode, url);

        expect(inMemoryShortcodeStorage.getUrl(shortcode)).to.equal(url);
        done();
    });

    it('returns undefined when shortcode does not exist', ()=>{
       expect(inMemoryShortcodeStorage.getUrl('non-existing-code')).to.be.undefined;
    });

    it('stores shortcode stats', ()=>{
        let stats = {};
        let shortcode = 'shortcode';

        inMemoryShortcodeStorage.saveStats(shortcode, <ShortcodeStats>stats);
        expect(inMemoryShortcodeStorage.getStats(shortcode)).to.equal(stats);
    });

    it('returns undefined when stats for shortcode do not exist', ()=>{
        expect(inMemoryShortcodeStorage.getStats('non-existing-code')).to.be.undefined;
    });
});