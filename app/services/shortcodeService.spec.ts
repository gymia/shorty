import sinon = require('sinon');
import chai = require('chai');
import sinonChai = require('sinon-chai');
import SinonStub = Sinon.SinonStub;

import {ShortcodeService} from './shortcodeService';
import {ShortcodeExistsError} from "../errors/shortcodeExistsError";

chai.use(sinonChai);
let expect = chai.expect;

describe('The shortcode service', ()=> {
    let shortcodeStorage;
    let shortcodeGenerator;
    let shortcodeService: ShortcodeService;

    beforeEach(()=> {
        shortcodeStorage = {
            addUrl: sinon.spy(),
            getUrl: ()=> {
            },
            saveStats: ()=> {
            },
            getStats: ()=> {
            }
        };

        shortcodeGenerator = {
            generate: ()=> {
            }
        };

        shortcodeService = new ShortcodeService(shortcodeStorage, shortcodeGenerator);
    });

    it('gets the url for a shortcode', ()=> {
        let shortcode = 'shortcode';
        let url = 'url';

        shortcodeStorage.getUrl = sinon.stub().returns(url);
        let result = shortcodeService.get(shortcode);
        expect(shortcodeStorage.getUrl).to.have.been.calledOnce;
        expect(result).to.equal(url);
    });

    it('generates a shortcode when none provided', (done)=> {
        let url = 'url';

        let pseudoRandom = 'abcd' + Math.round(Math.random() * 100);

        shortcodeGenerator.generate = sinon.stub().returns(pseudoRandom);
        expect(shortcodeService.save(url, undefined)).to.equal(pseudoRandom);
        expect(shortcodeStorage.addUrl).to.have.been.calledWith(pseudoRandom);
        done();
    });

    it('tries again if a generated shortcode exists', ()=> {
        let url = 'url';

        let pseudoRandom = 'abcd' + Math.round(Math.random() * 100);

        sinon.stub(shortcodeGenerator, 'generate');
        (<SinonStub>shortcodeGenerator.generate).onSecondCall().returns(pseudoRandom);

        sinon.stub(shortcodeService, 'exists').onFirstCall().returns(true);
        (<SinonStub>shortcodeService.exists).onSecondCall().returns(false);

        expect(shortcodeService.save(url)).to.equal(pseudoRandom);
        expect(shortcodeGenerator.generate).to.have.been.calledTwice;
    });

    it('saves a provided shortcode', ()=> {
        let shortcode = 'shortcode';
        let url = 'url';

        let result = shortcodeService.save(url, shortcode);
        expect(result).to.equal(shortcode);
        expect(shortcodeStorage.addUrl).to.have.been.calledOnce;
        expect(shortcodeStorage.addUrl).to.have.been.calledWith(shortcode, url);
    });


    it('throws an error when the provided shortcode already exists', ()=> {
        let shortcode = 'shortcode';
        let url = 'url';

        shortcodeStorage.getUrl = sinon.stub().returns('something');
        expect(() => {
            shortcodeService.save(shortcode, url)
        }).to.throw(ShortcodeExistsError);
    });

    it('saves stats for a new shortcode', ()=> {
        sinon.stub(shortcodeStorage, 'saveStats');

        let shortcode = 'shortcode';
        shortcodeService.save('test', shortcode);
        expect(shortcodeStorage.saveStats).to.have.been.calledOnce;
        expect(shortcodeStorage.saveStats).to.have.been.calledWith(shortcode, sinon.match.has('startDate').and(sinon.match.has('redirectCount')));
    });

    it('returns stats for a shortcode', ()=> {
        let shortcode = 'shortcode';
        let stats = {};

        sinon.stub(shortcodeStorage, 'getStats').returns(stats);

        expect(shortcodeService.getStats(shortcode)).to.equal(stats);
    });

    it('updates stats for a shortcode', ()=> {
        let shortcode = 'shortcode';
        let stats = {
            update: sinon.spy()
        };

        sinon.stub(shortcodeStorage, 'getStats').returns(stats);
        sinon.stub(shortcodeStorage, 'saveStats');

        shortcodeService.updateUsage(shortcode);

        expect(shortcodeStorage.getStats).to.have.been.calledWith(shortcode);
        expect(stats.update).to.have.been.calledOnce;
        expect(shortcodeStorage.saveStats).to.have.been.calledWith(shortcode, stats);
    });
});