import sinon = require('sinon');
import chai = require('chai');
import sinonChai = require('sinon-chai');
chai.use(sinonChai);
let expect = chai.expect;

import restify = require('restify');
import {StatsController} from './statsController';

describe('The stats controller', ()=> {
    let statsController: StatsController;
    let shortcodeService;

    let req;
    let res;
    const shortcode = 'aabbcc';

    beforeEach(()=> {
        shortcodeService = {
            getStats: ()=> {
            }
        };

        statsController = new StatsController(shortcodeService);

        req = {
            params: {
                shortcode: shortcode
            }
        };
        res = {
            json: sinon.spy()
        };
    });

    it('gets stats for a shortcode', (done)=> {
        let clock = sinon.useFakeTimers();

        let stats = {
            redirectCount: 2,
            startDate: new Date(),
            lastSeenDate: new Date()
        };

        sinon.stub(shortcodeService, 'getStats').returns(stats);

        statsController.get(req, res, <restify.Next>(()=> {
            expect(shortcodeService.getStats).to.have.been.calledOnce;
            expect(shortcodeService.getStats).to.have.been.calledWith(shortcode);

            expect(res.json).to.have.been.calledWith(200, {
                redirectCount: stats.redirectCount,
                startDate: "1970-01-01T00:00:00.000Z",
                lastSeenDate: "1970-01-01T00:00:00.000Z"
            });

            clock.restore();
            done();
        }));
    });

    it('returns 404 for a non-existing shortcode', (done)=> {
       sinon.stub(shortcodeService, 'getStats').returns(undefined);

        statsController.get(req, res, <restify.Next>(()=> {
            expect(res.json).to.have.been.calledWith(404);
            done();
        }));
    });
});