import sinon = require('sinon');
import chai = require('chai');
import sinonChai = require('sinon-chai');
import chaiDatetime = require('chai-datetime');
import {ShortcodeStats} from "./shortcodeStats";

chai.use(sinonChai);
chai.use(chaiDatetime);
let expect = chai.expect;

describe('The shortcode stats', ()=> {
    let clock;

    beforeEach(()=> {
        clock = sinon.useFakeTimers();
    });

    afterEach(()=> {
        clock.restore();
    });

    it('has initial values after creation', ()=> {
        let stats: ShortcodeStats = new ShortcodeStats();

        expect(stats.startDate).to.equalDate(new Date());
        expect(stats.redirectCount).to.equal(0);
        expect(stats.lastSeenDate).to.equal(undefined);
    });

    it('updates values', ()=> {
        let stats: ShortcodeStats = new ShortcodeStats();
        let startDate = new Date();

        clock.tick(24*3600*1000);
        stats.update();

        expect(stats.startDate).to.equalDate(startDate);
        expect(stats.lastSeenDate).to.equalDate(new Date());
        expect(stats.redirectCount).to.equal(1);

        stats.update();
        expect(stats.redirectCount).to.equal(2);
    });
});