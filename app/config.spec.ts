import {settings} from './config';
import chai = require('chai');

let expect = chai.expect;

describe('settings', ()=>{
    it('should have a name', ()=>{
        expect(settings.name).to.equal('shorty-typescript');
    });
});